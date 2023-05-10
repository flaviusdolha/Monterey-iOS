import Combine

// MARK: - ReportsInteractor

protocol ReportsInteractor: AnyObject {
    var state: ReportsState { get }
}

// MARK: - ReportsInteractorLive

final class ReportsInteractorLive: ReportsInteractor {
    
    // MARK: - Properties
    
    var state: ReportsState
    private let router: ReportsRouter
    
    // MARK: - Lifecycle

    init(router: ReportsRouter) {
        self.router = router
        state = ReportsState()
    }
}
