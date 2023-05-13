import Domain
import SwiftUI

// MARK: - ManageBudgetAssembly

final class ManageBudgetAssembly {
    
    // MARK: - Properties
    
    let transactionStorage: TransactionStorage
    let router: BudgetRouter
    
    // MARK: - Lifecycle
    
    init(transactionStorage: TransactionStorage, router: BudgetRouter) {
        self.transactionStorage = transactionStorage
        self.router = router
    }
    
    // MARK: - ManageBudgetView
    
    func manageBudgetView(type: ManageBudgetType, excluded: [ExpenseCategory]) -> ManageBudgetView {
        let interactor = ManageBudgetInteractorLive(
            transactionStorage: transactionStorage,
            router: router,
            type: type,
            excluded: excluded
        )
        let view = ManageBudgetView(interactor: interactor, state: interactor.state)
        return view
    }
}
