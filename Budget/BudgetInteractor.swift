import Core
import Combine
import Domain
import SwiftUI

// MARK: - BudgetInteractor

protocol BudgetInteractor: AnyObject {
    var state: BudgetState { get }
    
    func onAppear()
    func createBudgetButtonPressed()
    func budgetItemSelected(_ budget: BudgetValue)
    func dateString(from date: Date) -> String
    func monthNextButtonPressed()
    func monthPreviousButtonPressed()
}

// MARK: - BudgetInteractorLive

final class BudgetInteractorLive: BudgetInteractor {
    
    // MARK: - Properties
    
    var state: BudgetState
    private let router: BudgetRouter
    private let transactionStorage: TransactionStorage
    private var excluded = [ExpenseCategory]()
    private var budgets = [Budget]()
    
    // MARK: - Lifecycle

    init(router: BudgetRouter, transactionStorage: TransactionStorage) {
        self.router = router
        self.transactionStorage = transactionStorage
        state = BudgetState()
        loadData()
        loadCurrency()
    }
    
    func createBudgetButtonPressed() {
        router.push(.add(excluded: excluded))
    }
    
    func onAppear() {
        loadData()
    }
    
    func budgetItemSelected(_ budget: BudgetValue) {
        router.push(.edit(budget.budget, excluded: excluded))
    }

    func dateString(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        return "\(monthString(components: components)) \(yearString(components: components))"
    }
    
    func monthNextButtonPressed() {
        changeMonth(value: 1)
    }

    func monthPreviousButtonPressed() {
        changeMonth(value: -1)
    }
    
    private func loadData() {
        budgets = transactionStorage.getBudgets()
        filterData()
        filterExcluded()
    }
    
    private func loadCurrency() {
        if let currencyString = UserDefaults.standard.string(forKey: UserDefaultsKeys.currency),
           let currency = Currency(rawValue: currencyString) {
            state.currency = currency
        }
    }
    
    private func filterExcluded() {
        self.excluded = state.budgets.compactMap { budget in
            var cat: ExpenseCategory? = nil
            if let category = budget.budget.category,
               let expenseCategory = ExpenseCategory(rawValue: category) {
                cat = expenseCategory
            }
            return cat
        }
    }
    
    private func monthString(components: DateComponents) -> String {
        if let month = components.month?.monthString {
            return month.localized
        }
        return ""
    }
    
    private func yearString(components: DateComponents) -> String {
        if let year = components.year {
            return String(year)
        }
        return ""
    }

    private func changeMonth(value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: state.selectedMonthDate) {
            state.selectedMonthDate = newDate
            filterData()
        }
    }
    
    private func filterData() {
        let transactions = transactionStorage.getTransactions()
        let components = Calendar(identifier: .gregorian).dateComponents([.month, .year], from: state.selectedMonthDate)
        guard let year = components.year, let month = components.month else { return }
        state.budgets = budgets.map { budget in
            let totalValue = transactions.filter { transaction in
                guard let date = transaction.date else { return false }
                let dcomponents = Calendar(identifier: .gregorian).dateComponents([.month, .year], from: date)
                if let category = transaction.category,
                   let expenseCategory = ExpenseCategory(rawValue: category),
                   let bCategory = budget.category,
                   let bExpenseCategory = ExpenseCategory(rawValue: bCategory),
                   let dyear = dcomponents.year,
                   let dmonth = dcomponents.month {
                    return (bExpenseCategory == .none ? true : (expenseCategory == bExpenseCategory)) && month == dmonth && year == dyear
                }
                return false
            }.reduce(0) { round(($0 + $1.price) * 100.0) / 100.0 }
            return BudgetValue(budget: budget, totalExpensesValue: totalValue)
        }
    }
}
