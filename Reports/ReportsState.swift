import Combine
import Domain

// MARK: - PeriodType

enum PeriodType {
    case monthly
    case yearly
}

// MARK: - ExpenseData

struct ExpenseData: Identifiable {
    let category: String
    let totalValue: Float
    
    var id: String {
        category
    }
}

struct ExpenseMonth: Identifiable {
    let date: Date
    let totalValue: Float
    
    var id: Date {
        date
    }
}

// MARK: - ReportsState

final class ReportsState: ObservableObject {
    @Published var selectedMonth: Int = 1
    @Published var selectedYear: Int = 2023
    @Published var showCharts = false
    @Published var expenses = [ExpenseData]()
    @Published var currency: Currency = .usd
    @Published var periodType: PeriodType = .monthly
    @Published var periodString = ""
    @Published var expensesByMonth = [ExpenseMonth]()
}
