import SharedState
import SwiftUI

// MARK: - TransactionsAssembly

public final class TransactionsAssembly {
    
    // MARK: - Properties

    private let environment: TransactionsEnvironment

    // MARK: - Lifecycle

    public init(transactionsSharedState: TransactionsSharedState) {
        environment = TransactionsEnvironmentLive(transactionsSharedState: transactionsSharedState)
    }
    
    // MARK: - TransactionsView
    
    public func TransactionsView() -> TransactionsView {
        let interactor = TransactionsInteractorLive(
            transactionStorage: environment.transactionStorage,
            router: environment.router,
            transactionsSharedState: environment.transactionsSharedState
        )
        let view = Transactions.TransactionsView(interactor: interactor, state: interactor.state, router: environment.router)
        return view
    }
}
