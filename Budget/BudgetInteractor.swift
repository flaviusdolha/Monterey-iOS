import Core
import Combine
import Domain
import SwiftUI

// MARK: - BudgetInteractor

protocol BudgetInteractor: AnyObject {
    var state: BudgetState { get }
    
    func onAppear()
    func createBudgetButtonPressed()
}

// MARK: - BudgetInteractorLive

final class BudgetInteractorLive: BudgetInteractor {
    
    // MARK: - Properties
    
    var state: BudgetState
    private let router: BudgetRouter
    private let transactionStorage: TransactionStorage
    
    // MARK: - Lifecycle

    init(router: BudgetRouter, transactionStorage: TransactionStorage) {
        self.router = router
        self.transactionStorage = transactionStorage
        state = BudgetState()
        loadData()
    }
    
    func createBudgetButtonPressed() {
        router.push(.add)
    }
    
    func onAppear() {
        loadData()
    }
    
    private func loadData() {
        state.budgets = transactionStorage.getBudgets()
    }
}
