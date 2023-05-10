import Combine
import Domain
import SharedState

// MARK: - MainRoute

enum MainRoute: Hashable {
    case transactions
    case scan
    case reports
    case settings
}

// MARK: - MainState

final class MainState: ObservableObject {
    @Published var route: MainRoute = .transactions
    var transactionsSharedState = TransactionsSharedState()
}
