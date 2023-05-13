import Combine
import Domain

// MARK: - BudgetState

final class BudgetState: ObservableObject {
    @Published var budgets: [Budget] = []
}
