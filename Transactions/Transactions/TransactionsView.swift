import Core
import Design
import Domain
import SwiftUI

// MARK: - TransactionsView

public struct TransactionsView: View {
    
    // MARK: - Properties

    var interactor: TransactionsInteractor?
    @ObservedObject var state: TransactionsState
    @ObservedObject var router: TransactionsRouter
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: router.binding) {
            ZStack {
                VStack {
                    calendarView
                    transactionTypePicker
                    if !state.currentIncomes.isEmpty || !state.currentTransactions.isEmpty {
                        balanceView
                    }
                    switch state.selectedTransactionType {
                    case .expense: expenseList
                    case .income: incomeList
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        addIncomeFloatingButton
                    }
                    HStack {
                        Spacer()
                        addFloatingButton
                    }
                }
            }
            .montereyNavBar()
            .montereyTabBar()
            .navigationTitle("Summary".localized)
            .toolbar {
                Button("Add".localized) {
                    if state.selectedTransactionType == .expense {
                        interactor?.addButtonPressed()
                    } else {
                        interactor?.addIncomeButtonPressed()
                    }
                }
            }
            .navigationDestination(for: TransactionsRoute.self) { route in
                router.view(for: route)
            }
            .onAppear {
                interactor?.onAppear()
            }
        }
    }
    
    private var addFloatingButton: some View {
        Button {
            interactor?.addButtonPressed()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.mint)
                    .frame(width: 64, height: 64)
                Image(systemName: "cart.fill.badge.plus")
                    .foregroundColor(.white)
                    .font(.system(size: 28))
            }
        }
        .padding()
    }
    
    private var addIncomeFloatingButton: some View {
        Button {
            interactor?.addIncomeButtonPressed()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.mint)
                    .frame(width: 64, height: 64)
                Image(systemName: "doc.fill.badge.plus")
                    .foregroundColor(.white)
                    .font(.system(size: 28))
            }
        }
        .padding(.horizontal)
    }
    
    private func transactionCategoryView(_ transactionCategory: TransactionCategory) -> some View {
        HStack {
            ZStack {
                GeometryReader { reader in
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(transactionCategory.category.color.opacity(0.20))
                        .frame(width: reader.size.width * CGFloat(transactionCategory.transactions.totalPrice / state.currentTransactions.totalPrice), height: 24)
                }
                    .offset(y: 6)
                HStack {
                    Text(transactionCategory.category.emoji + " " + transactionCategory.category.rawValue.capitalized.localized)
                    Spacer()
                    Text(String(transactionCategory.transactions.totalPrice) + state.currency.symbol)
                        .foregroundColor(.gray)
                }
            }
            Button {
                withAnimation {
                    interactor?.transactionCategoryPressed(transactionCategory)
                }
            } label: {
                Image(systemName: transactionCategory.isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(transactionCategory.category.color)
            }
        }
    }
    
    private func transactionItem(_ transaction: Domain.Transaction) -> some View {
        HStack {
            Text(transaction.note ?? "")
                .font(.callout)
            Spacer()
            Text(String(transaction.price) + " \(state.currency.symbol)")
                .font(.callout)
                .foregroundColor(.gray)
            Image(systemName: "arrow.right")
                .foregroundColor(.gray)
        }
        .onTapGesture {
            interactor?.transactionSelected(transaction)
        }
    }
    
    private func incomeItem(_ income: IncomeData) -> some View {
        HStack {
            Text((IncomeCategory(rawValue: income.category ?? "")?.emoji ?? "") + " " + (income.category ?? "").capitalized.localized)
                .font(.callout)
            Spacer()
            Text(String(income.value) + "\(state.currency.symbol)")
                .font(.callout)
                .foregroundColor(.gray)
            Image(systemName: "arrow.right")
                .foregroundColor(.gray)
        }
        .onTapGesture {
            interactor?.incomeSelected(income)
        }
    }
    
    private var calendarView: some View {
        HStack {
            HStack {
                Button {
                    withAnimation {
                        interactor?.monthPreviousButtonPressed()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.mint)
                }
                Spacer()
                Label {
                    Text(interactor?.dateString(from: state.selectedMonthDate) ?? "")
                        .foregroundColor(.mint)
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundColor(.mint)
                }
                Spacer()
                Button {
                    withAnimation {
                        interactor?.monthNextButtonPressed()
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.mint)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 4)
        }
        .background(Color.white)
    }
    
    private var expenseList: some View {
        VStack {
            if state.currentTransactions.isEmpty {
                Spacer()
                Text("There are currently no transactions for the selected time period.\n\nStart by adding one.".localized)
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
                Spacer()
            } else {
                List {
                    HStack {
                        Text("\("Total expenses".localized): ")
                        + Text(String(state.currentTransactions.totalPrice) + " " + state.currency.symbol)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    ForEach(state.currentTransactions) { transactionCategory in
                        Section {
                            transactionCategoryView(transactionCategory)
                            if transactionCategory.isExpanded {
                                ForEach(transactionCategory.transactions) { transaction in
                                    transactionItem(transaction)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollIndicators(.hidden)
            }
        }
    }
    
    private var incomeList: some View {
        VStack {
            if state.currentIncomes.isEmpty {
                Spacer()
                Text("There is currently no income for the selected time period.\n\nStart by adding one.".localized)
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
                Spacer()
            } else {
                List {
                    HStack {
                        Text("\("Total income".localized): ")
                        + Text(String(state.currentIncomes.totalValue) + " " + state.currency.symbol)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    ForEach(state.currentIncomes) { income in
                        Section {
                            incomeItem(income)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollIndicators(.hidden)
            }
        }
    }
    
    private var transactionTypePicker: some View {
        HStack {
            Spacer()
            Picker("Transaction Type", selection: $state.selectedTransactionType) {
                Text("Expenses".localized).tag(TransactionType.expense)
                Text("Income".localized).tag(TransactionType.income)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onAppear() {
                UISegmentedControl.appearance().selectedSegmentTintColor = .systemMint
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            }
            Spacer()
        }
    }
    
    private var balanceView: some View {
        HStack {
            Text("Balance: ")
                .font(.title3)
            + Text(balance.value + " " + state.currency.symbol)
                .foregroundColor(balance.color)
                .fontWeight(.bold)
                .font(.title3)
            Spacer()
        }
        .padding(.top, 4)
        .padding(.horizontal)
        .padding(.horizontal, 8)
    }
    
    private var balance: (value: String, color: Color) {
        let value = state.currentIncomes.totalValue - state.currentTransactions.totalPrice
        let color = colour(for: value)
        let stringValue = "\(value > 0.0 ? "+" : "")" + String(format: "%.2f", value)
        return (stringValue, color)
    }
    
    private func colour(for value: Float) -> Color {
        if value == 0.0 {
            return .black
        } else if value < 0.0 {
            return .red
        } else {
            return .green
        }
    }
}
