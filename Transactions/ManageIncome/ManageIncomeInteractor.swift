import Combine
import Core
import Domain
import SwiftUI

// MARK: - ManageIncomeInteractor

protocol ManageIncomeInteractor: AnyObject {
    var state: ManageIncomeState { get }
    
    func actionButtonPressed()
    func confirmDeleteIncome()
}

// MARK: - ManageIncomeInteractorLive

final class ManageIncomeInteractorLive: ManageIncomeInteractor {
    
    // MARK: - Properties
    
    var state: ManageIncomeState
    private let transactionStorage: TransactionStorage
    private let router: TransactionsRouter
    private var income: IncomeData? = nil
    
    // MARK: - Lifecycle

    init(
        transactionStorage: TransactionStorage,
        router: TransactionsRouter,
        type: ManageIncomeType
    ) {
        self.transactionStorage = transactionStorage
        self.router = router
        var incomeDataModel: IncomeDataModel
        switch type {
        case .add:
            incomeDataModel = .default
        case .edit(let incomingIncome):
            self.income = incomingIncome
            incomeDataModel = incomingIncome.data
        }
        state = ManageIncomeState(income: incomeDataModel, type: type)
        loadCurrency()
    }
    
    func actionButtonPressed() {
        switch state.type {
        case .add:
            transactionStorage.saveIncome(date: state.income.date, value: round(state.income.value * 100) / 100.0, category: state.income.category.rawValue
            )
        case .edit:
            if let income = income {
                transactionStorage.updateIncome(income, date: state.income.date, value: round(state.income.value * 100) / 100.0, category: state.income.category.rawValue)
            }
        }
        router.dismiss()
    }
    
    func confirmDeleteIncome() {
        if let income = income {
            transactionStorage.deleteIncome(income)
        }
        router.dismiss()
    }
    
    private func loadCurrency() {
        if let currencyString = UserDefaults.standard.string(forKey: UserDefaultsKeys.currency),
           let currency = Currency(rawValue: currencyString) {
            state.currency = currency
        }
    }
}
