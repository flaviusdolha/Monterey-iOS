import Combine
import Core
import Domain
import SharedState

// MARK: - TransactionsInteractor

protocol TransactionsInteractor: AnyObject {
    var state: TransactionsState { get }
    
    func addButtonPressed()
    func addIncomeButtonPressed()
    func onAppear()
    func transactionSelected(_ transaction: Transaction)
    func incomeSelected(_ income: IncomeData)
    func transactionCategoryPressed(_ transactionCategory: TransactionCategory)
    func dateString(from date: Date) -> String
    func monthNextButtonPressed()
    func monthPreviousButtonPressed()
}

// MARK: - TransactionsInteractorLive

final class TransactionsInteractorLive: TransactionsInteractor {
    
    // MARK: - Properties
    
    var state: TransactionsState
    private let transactionStorage: TransactionStorage
    private let router: TransactionsRouter
    private let transactionsSharedState: TransactionsSharedState
    
    // MARK: - Lifecycle

    init(transactionStorage: TransactionStorage, router: TransactionsRouter, transactionsSharedState: TransactionsSharedState) {
        self.transactionStorage = transactionStorage
        self.router = router
        self.transactionsSharedState = transactionsSharedState
        state = TransactionsState()
        loadData()
        loadCurrency()
    }

    // MARK: - Public Methods
    
    func addButtonPressed() {
        router.push(.add)
    }
    
    func addIncomeButtonPressed() {
        router.push(.addIncome)
    }
    
    func onAppear() {
        loadData()
        if let addTransaction = transactionsSharedState.addTransaction, addTransaction {
            transactionsSharedState.addTransaction = nil
            router.push(.add)
        }
    }
    
    func transactionSelected(_ transaction: Transaction) {
        router.push(.edit(transaction))
    }
    
    func incomeSelected(_ income: IncomeData) {
        router.push(.editIncome(income))
    }
    
    func transactionCategoryPressed(_ transactionCategory: TransactionCategory) {
        if let index = state.currentTransactions.firstIndex(where: { $0.id == transactionCategory.id }) {
            state.currentTransactions[index].isExpanded.toggle()
        }
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

    // MARK: - Private Methods
    
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

    private func loadData() {
        let transactions = transactionStorage.getTransactions()
        state.incomes = transactionStorage.getIncomes()
        state.transactionCategories = convertToTransactionCategories(transactions, responseInit: { category, transactions in
            TransactionCategory(category: category, transactions: transactions)
        }, categoryInit: { value in
            guard let value = value else { return nil }
            return ExpenseCategory(rawValue: value)
        })
        filterTransactionsData()
    }
    
    private func loadCurrency() {
        if let currencyString = UserDefaults.standard.string(forKey: UserDefaultsKeys.currency),
           let currency = Currency(rawValue: currencyString) {
            state.currency = currency
        }
    }
    
    private func filterTransactionsData() {
        filterCurrentIncomes()
        filterCurrentTransactionCategories()
    }
    
    private func convertToTransactionCategories<T: Categorizable, R, C: Hashable & RawRepresentable>(_ data: [T], responseInit: (C, [T]) -> R, categoryInit: (String?) -> C?) -> [R] where C.RawValue == String {
        var categoriesTransactions: [C: [T]] = [:]
        data.forEach { dataElement in
            guard let dataCategory = dataElement.category,
                  let category = categoryInit(dataCategory)
            else { return }
            if let trans = categoriesTransactions[category] {
                var trns = trans
                trns.append(dataElement)
                categoriesTransactions[category] = trns
            } else {
                categoriesTransactions[category] = [dataElement]
            }
        }
        
        return categoriesTransactions.map { category, transactions in
            responseInit(category, transactions)
        }
    }
    
    private func filterCurrentTransactionCategories() {
        var currentTransactions: [TransactionCategory] = []
        state.transactionCategories.forEach { category in
            let transactions = category.transactions.filter { transaction in
                let currentDateMonth = Calendar.current.dateComponents([.month, .year], from: state.selectedMonthDate)
                guard let transactionDate = transaction.date else {
                    return false
                }
                let transactionDateMonth = Calendar.current.dateComponents([.month, .year], from: transactionDate)
                return currentDateMonth.month == transactionDateMonth.month && currentDateMonth.year == transactionDateMonth.year
            }
            if !transactions.isEmpty {
                let newTransactionCategory = TransactionCategory(category: category.category, transactions: transactions, isExpanded: category.isExpanded)
                currentTransactions.append(newTransactionCategory)
            }
        }
        state.currentTransactions = currentTransactions.sorted(by: { tc1, tc2 in
            tc1.transactions.totalPrice > tc2.transactions.totalPrice
        })
    }

    private func filterCurrentIncomes() {
        let currentIncomes = state.incomes.filter { income in
            let currentDateMonth = Calendar.current.dateComponents([.month, .year], from: state.selectedMonthDate)
            guard let incomeDate = income.date else { return false }
            let incomeDateMonth = Calendar.current.dateComponents([.month, .year], from: incomeDate)
            return currentDateMonth.month == incomeDateMonth.month && currentDateMonth.year == incomeDateMonth.year
        }
        state.currentIncomes = currentIncomes.sorted(by: { i1, i2 in
            i1.value > i2.value
        })
    }
    
    private func changeMonth(value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: state.selectedMonthDate) {
            state.selectedMonthDate = newDate
            filterTransactionsData()
        }
    }
}
