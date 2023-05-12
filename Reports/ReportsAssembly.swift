import SwiftUI

// MARK: - ReportsAssembly

public final class ReportsAssembly {
    
    // MARK: - Properties
    
    private let environment: ReportsEnvironment
    
    // MARK: - Lifecycle
    
    public init() {
        environment = ReportsEnvironmentLive()
    }
    
    // MARK: - ReportsView
    
    public func reportsView() -> ReportsView {
        let interactor = ReportsInteractorLive(router: environment.router, transactionStorage: environment.transactionStorage)
        let view = ReportsView(interactor: interactor, state: interactor.state, router: environment.router)
        return view
    }
}
