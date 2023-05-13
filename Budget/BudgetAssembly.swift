import SwiftUI

// MARK: - BudgetAssembly

public final class BudgetAssembly {
    
    // MARK: - Properties
    
    private let environment: BudgetEnvironment
    
    // MARK: - Lifecycle
    
    public init() {
        environment = BudgetEnvironmentLive()
    }
    
    // MARK: - BudgetView
    
    public func budgetView() -> BudgetView {
        let interactor = BudgetInteractorLive(router: environment.router, transactionStorage: environment.transactionStorage)
        let view = BudgetView(interactor: interactor, state: interactor.state, router: environment.router)
        return view
    }
}
