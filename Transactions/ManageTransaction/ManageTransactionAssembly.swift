import Domain
import SharedState
import SwiftUI

// MARK: - ManageTransactionAssembly

final class ManageTransactionAssembly {
    
    // MARK: - Properties
    
    let transactionStorage: TransactionStorage
    let router: TransactionsRouter
    let transactionsSharedState: TransactionsSharedState
    
    // MARK: - Lifecycle
    
    init(transactionStorage: TransactionStorage, router: TransactionsRouter, transactionsSharedState: TransactionsSharedState) {
        self.transactionStorage = transactionStorage
        self.router = router
        self.transactionsSharedState = transactionsSharedState
    }
    
    // MARK: - ManageTransactionView
    
    func ManageTransactionView(type: ManageTransactionType) -> ManageTransactionView {
        let interactor = ManageTransactionInteractorLive(
            transactionStorage: transactionStorage,
            router: router,
            type: type,
            transactionsSharedState: transactionsSharedState
        )
        let view = Transactions.ManageTransactionView(interactor: interactor, state: interactor.state)
        return view
    }
}
