import Core
import Combine
import Domain
import SwiftUI

// MARK: - BudgetInteractor

protocol BudgetInteractor: AnyObject {
    var state: BudgetState { get }
    
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
    }
    
    func createBudgetButtonPressed() {
        
    }
}
