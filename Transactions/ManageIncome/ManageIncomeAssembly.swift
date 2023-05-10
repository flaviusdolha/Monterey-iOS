import Domain
import SwiftUI

// MARK: - ManageIncomeAssembly

final class ManageIncomeAssembly {
    
    // MARK: - Properties
    
    let transactionStorage: TransactionStorage
    let router: TransactionsRouter
    
    // MARK: - Lifecycle
    
    init(transactionStorage: TransactionStorage, router: TransactionsRouter) {
        self.transactionStorage = transactionStorage
        self.router = router
    }
    
    // MARK: - ManageIncomeView
    
    func manageIncomeView(type: ManageIncomeType) -> ManageIncomeView {
        let interactor = ManageIncomeInteractorLive(
            transactionStorage: transactionStorage,
            router: router,
            type: type
        )
        let view = ManageIncomeView(interactor: interactor, state: interactor.state)
        return view
    }
}
