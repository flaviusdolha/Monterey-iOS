import Combine
import ReceiptScanner
import Settings
import SwiftUI
import Transactions

// MARK: - MainInteractor

protocol MainInteractor: AnyObject {
    var state: MainState { get }
    var scannerView: AnyView { get }
    var transactionsView: AnyView { get }
    var settingsView: AnyView { get }
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

    var scannerView: AnyView {
        AnyView(scannerAssembly.scannerView())
    }
    
    var transactionsView: AnyView {
        AnyView(transactionsAssembly.TransactionsView())
    }
    
    var settingsView: AnyView {
        AnyView(settingsAssembly.settingsView())
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
    }
}
