import Authentication
import Budget
import Core
import Combine
import Domain
import Foundation
import ReceiptScanner
import Reports
import Settings
import SwiftUI
import Transactions

// MARK: - MainInteractor

protocol MainInteractor: AnyObject {
    var state: MainState { get }
    var scannerView: AnyView { get }
    var transactionsView: AnyView { get }
    var reportsView: AnyView { get }
    var settingsView: AnyView { get }
    var authenticationView: AnyView { get }
    var budgetView: AnyView { get }
}

// MARK: - MainInteractorLive

final class MainInteractorLive: MainInteractor {
    
    // MARK: - Properties
    
    var state: MainState
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var scannerAssembly: ScannerAssembly = {
        ScannerAssembly(transactionsSharedState: state.transactionsSharedState)
    }()
    
    private lazy var transactionsAssembly: TransactionsAssembly = {
        TransactionsAssembly(transactionsSharedState: state.transactionsSharedState)
    }()
    
    private lazy var settingsAssembly: SettingsAssembly = {
        SettingsAssembly()
    }()
    
    private lazy var reportsAssembly: ReportsAssembly = {
        ReportsAssembly()
    }()
    
    private lazy var authenticationAssembly: AuthenticationAssembly = {
        AuthenticationAssembly()
    }()
    
    private lazy var budgetAssembly: BudgetAssembly = {
        BudgetAssembly()
    }()

    var scannerView: AnyView {
        AnyView(scannerAssembly.scannerView())
    }
    
    var transactionsView: AnyView {
        AnyView(transactionsAssembly.TransactionsView())
    }
    
    var settingsView: AnyView {
        AnyView(settingsAssembly.settingsView())
    }
    
    var reportsView: AnyView {
        AnyView(reportsAssembly.reportsView())
    }
    
    var authenticationView: AnyView {
        AnyView(authenticationAssembly.authenticationView())
    }
    
    var budgetView: AnyView {
        AnyView(budgetAssembly.budgetView())
    }
    
    // MARK: - Lifecycle

    init() {
        state = MainState()
        scannerAssembly.externalRouter.sink { [weak self] route in
            switch route {
            case .transaction(let price, let picture):
                self?.state.transactionsSharedState.addTransaction = true
                self?.state.transactionsSharedState.price = price
                self?.state.transactionsSharedState.picture = picture
                self?.state.route = .transactions
            }
        }
        .store(in: &cancellables)
        authenticationAssembly.externalRouter.sink { [weak self] route in
            switch route {
            case .authenticated:
                DispatchQueue.main.async {
                    withAnimation {
                        self?.state.isAuthenticated = true
                    }
                }
            }
        }
        .store(in: &cancellables)
        guard let _ = UserDefaults.standard.string(forKey: UserDefaultsKeys.currency) else {
            UserDefaults.standard.set(Currency.usd.rawValue, forKey: UserDefaultsKeys.currency)
            return
        }
    }
}
