import Combine
import Domain

// MARK: - ManageBudgetType

enum ManageBudgetType: Equatable {
    case add
    case edit(Budget)
}

// MARK: - ManageBudgetState

final class ManageBudgetState: ObservableObject {
    @Published var type: ManageBudgetType
    @Published var isShowingConfirmDelete: Bool = false
    @Published var currency: Currency = .usd
    @Published var category: ExpenseCategory = .none
    @Published var value: Float = 0.0
    
    init(type: ManageBudgetType) {
        self.type = type
    }
}
