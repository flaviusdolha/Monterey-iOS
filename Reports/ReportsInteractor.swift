import Combine
import Core
import Domain
import SwiftUI

// MARK: - ReportsInteractor

protocol ReportsInteractor: AnyObject {
    var state: ReportsState { get }
    
    func onGenerateReportsButtonPressed()
    func onAppear()
}

// MARK: - ReportsInteractorLive

final class ReportsInteractorLive: ReportsInteractor {
    
    // MARK: - Properties
    
    var state: ReportsState
    private let router: ReportsRouter
    private let transactionStorage: TransactionStorage
    private var transactions: [Domain.Transaction]
    
    // MARK: - Lifecycle

    init(router: ReportsRouter, transactionStorage: TransactionStorage) {
        self.router = router
        self.transactionStorage = transactionStorage
        transactions = transactionStorage.getTransactions()
        state = ReportsState()
        let dateComponents = Calendar(identifier: .gregorian).dateComponents([.month, .year], from: .now)
        if let month = dateComponents.month {
            state.selectedMonth = month
        }
        if let year = dateComponents.year {
            state.selectedYear = year
        }
        loadCurrency()
    }
    
    func onGenerateReportsButtonPressed() {
        let currentTransactions = getTransactionsInCurrentPeriod()
        var expenses = [String: Float]()
        currentTransactions.forEach { transaction in
            guard let category = transaction.category
            else { return }
            if let currentPrice = expenses[category] {
                expenses[category] = round((currentPrice + transaction.price) * 100.0) / 100.0
            } else {
                expenses[category] = transaction.price
            }
        }
        state.expenses = expenses.map { category, totalValue in
            ExpenseData(category: category, totalValue: totalValue)
        }.sorted(by: { $0.category < $1.category })
        
        withAnimation {
            if state.periodType == .yearly {
                state.expensesByMonth = getExpensesByMonth(currentTransactions)
            }
            state.periodString = "\(state.periodType == .monthly ? "\(state.selectedMonth.monthString ?? "") " : "")\(state.selectedYear)"
            state.showCharts = true
        }
    }
    
    func onAppear() {
        transactions = transactionStorage.getTransactions()
    }
    
    private func getExpensesByMonth(_ transactions: [Domain.Transaction]) -> [ExpenseMonth] {
        var expensesByMonth = [Float](repeating: 0.0, count: 12)
        transactions.forEach { transaction in
            guard let date = transaction.date else {
                return
            }
            let month = Calendar(identifier: .gregorian).component(.month, from: date)
            expensesByMonth[month - 1] = round((expensesByMonth[month - 1] + transaction.price) * 100.0) / 100.0
        }
        return expensesByMonth.enumerated().map { i, value in
            var date = DateComponents()
            date.month = i + 1
            date.year = state.selectedYear
            return ExpenseMonth(date: Calendar(identifier: .gregorian).date(from: date)!, totalValue: value)
        }
    }
    
    private func getTransactionsInCurrentPeriod() -> [Domain.Transaction] {
        transactions.filter { transaction in
            guard let date = transaction.date else {
                return false
            }
            let dateComponents = Calendar(identifier: .gregorian).dateComponents([.month, .year], from: date)
            guard let month = dateComponents.month,
                  let year = dateComponents.year
            else { return false }
            return (state.periodType == .monthly ? month == state.selectedMonth : true) && year == state.selectedYear
        }
    }
    
    private func loadCurrency() {
        if let currencyString = UserDefaults.standard.string(forKey: UserDefaultsKeys.currency),
           let currency = Currency(rawValue: currencyString) {
            state.currency = currency
        }
    }
}
