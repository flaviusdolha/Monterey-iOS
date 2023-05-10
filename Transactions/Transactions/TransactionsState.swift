import Combine
import Domain
import SwiftUI

enum TransactionType: String, Hashable {
    case expense = "Expense"
    case income = "Income"
}

// MARK: - TransactionsState

final class TransactionsState: ObservableObject {
    @Published var transactionCategories: [TransactionCategory] = []
    @Published var currentTransactions: [TransactionCategory] = []
    @Published var incomes: [IncomeData] = []
    @Published var currentIncomes: [IncomeData] = []
    @Published var totalPrice = 0
    @Published var selectedMonthDate = Date()
    @Published var currency: Currency = .usd
    @Published var selectedTransactionType: TransactionType = .expense
}
