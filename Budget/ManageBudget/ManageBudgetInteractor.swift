import Combine
import Core
import Domain
import SwiftUI

// MARK: - ManageBudgetInteractor

protocol ManageBudgetInteractor: AnyObject {
    var state: ManageBudgetState { get }
    
    func actionButtonPressed()
    func confirmDeleteBudget()
}

// MARK: - ManageBudgetInteractorLive

final class ManageBudgetInteractorLive: ManageBudgetInteractor {
    
    // MARK: - Properties
    
    var state: ManageBudgetState
    private let transactionStorage: TransactionStorage
    private let router: BudgetRouter
    private let budget: Budget? = nil
    
    // MARK: - Lifecycle

    init(
        transactionStorage: TransactionStorage,
        router: BudgetRouter,
        type: ManageBudgetType
    ) {
        self.transactionStorage = transactionStorage
        self.router = router
        state = ManageBudgetState(type: type)
        if case .edit(let budget) = type {
            self.budget = budget
            state.value = budget.value
            if let category = budget.category,
               let expenseCategory = ExpenseCategory(rawValue: category) {
                state.category = expenseCategory
            }
        }
        loadCurrency()
    }
    
    func actionButtonPressed() {
        switch state.type {
        case .add:
            transactionStorage.saveBudget(category: state.category.rawValue, value: round(state.value * 100.0) / 100.0)
        case .edit:
            if let budget = budget {
                transactionStorage.updateBudget(budget, category: state.category.rawValue, value: round(state.value * 100.0) / 100.0)
            }
        }
        router.dismiss()
    }
    
    func confirmDeleteIncome() {
        if let budget = budget {
            transactionStorage.deleteBudget(budget)
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
