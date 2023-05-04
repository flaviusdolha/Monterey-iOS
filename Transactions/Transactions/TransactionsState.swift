import Combine
import Domain
import SwiftUI


// MARK: - TransactionsState

final class TransactionsState: ObservableObject {
    @Published var transactionCategories: [TransactionCategory] = []
    @Published var currentTransactions: [TransactionCategory] = []
    @Published var totalPrice = 0
    @Published var selectedMonthDate = Date()
}
