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
        let dateComponents = Calendar(identifier: .gregorian).dateComponents([.month, .year], from: .now)
        if let month = dateComponents.month {
            state.selectedMonth = month
        }
        if let year = dateComponents.year {
            state.selectedYear = year
        }
    }
}
