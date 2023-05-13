import Combine
import Domain

// MARK: - BudgetValue

struct BudgetValue {
    let budget: Budget
    let totalExpensesValue: Float
    
    var percentange: Float {
        if totalExpensesValue >= budget.amount { return 1.0 }
        else { return totalExpensesValue / budget.amount }
    }
    
    var remaining: Float {
        round((budget.amount - totalExpensesValue) * 100.0) / 100.0
    }
}

// MARK: - BudgetState

final class BudgetState: ObservableObject {
    @Published var budgets: [BudgetValue] = []
    @Published var currency: Currency = .usd
    @Published var selectedMonthDate = Date()
}
