import Core
import Design
import Domain
import SwiftUI

// MARK: - BudgetView

public struct BudgetView: View {
    
    // MARK: - Properties

    var interactor: BudgetInteractor?
    @ObservedObject var state: BudgetState
    @ObservedObject var router: BudgetRouter
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: router.binding) {
            ZStack {
                List {
                    Section {
                        headline
                    }
                    if state.budgets.isEmpty {
                        Section {
                            Text("There aren't any budgets. Start by creating one.")
                                .foregroundColor(.gray)
                        }
                    } else {
                        Section {
                            calendarView
                        } header: {
                            Text("Period".localized)
                        }
                        Section {
                            ForEach(state.budgets, id: \.budget) { budget in
                                budgetItem(budget)
                            }
                        } header: {
                            Text("Budgets".localized)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollIndicators(.hidden)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        createBudgetFloatingButton
                    }
                }
            }
                .montereyNavBar()
                .montereyTabBar()
                .navigationTitle("Budgets".localized)
                .navigationDestination(for: BudgetRoute.self) { route in
                    router.view(for: route)
                }
                .toolbar {
                    Button("Create".localized) {
                        interactor?.createBudgetButtonPressed()
                    }
                }
                .tint(.mint)
                .onAppear {
                    interactor?.onAppear()
                }
        }
    }
    
    private var headline: some View {
        HStack {
            Image(systemName: "chart.pie.fill")
                .foregroundColor(.mint)
                .font(.system(size: 64))
            VStack(spacing: 4) {
                Spacer()
                HStack {
                    Text("Budgets")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack {
                    Text("Organise your financial behaviour by setting up monthly budgets.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    private var createBudgetFloatingButton: some View {
        Button {
            interactor?.createBudgetButtonPressed()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.mint)
                    .frame(width: 64, height: 64)
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 28))
            }
        }
        .padding()
    }
    
    private func budgetItem(_ budget: BudgetValue) -> some View {
        VStack {
            HStack {
                if let category = budget.budget.category,
                   let expenseCategory = ExpenseCategory(rawValue: category) {
                    if expenseCategory == .none {
                        Text("💸 All Wallet".localized)
                            .font(.callout)
                    } else {
                        Text(expenseCategory.emoji + " " + expenseCategory.rawValue.capitalized.localized)
                            .font(.callout)
                    }
                }
                Text("(" + String(budget.remaining) + "\(state.currency.symbol)" + " left".localized + ")")
                    .font(.caption)
                    .foregroundColor(budget.remaining < 0 ? .red : .gray)
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(budget.totalExpensesValue > 0 ? Color.fromRedToGreem(green: 1.0 - budget.percentange).opacity(0.15) : .gray.opacity(0.15))
                    .frame(height: 24)
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.fromRedToGreem(green: 1.0 - budget.percentange).opacity(0.4))
                        .frame(width: (UIScreen.main.bounds.size.width - 64.0) * CGFloat(budget.percentange), height: 24)
                    if budget.percentange < 1.0 {
                        Spacer()
                    }
                }
                HStack {
                    Text(String(budget.totalExpensesValue) + "\(state.currency.symbol)")
                        .font(.callout)
                    Spacer()
                    Text(String(budget.budget.amount) + "\(state.currency.symbol)")
                        .font(.callout)
                }
            }
        }
        .onTapGesture {
            interactor?.budgetItemSelected(budget)
        }
    }
    
    private var calendarView: some View {
        HStack {
            Button {
                withAnimation {
                    interactor?.monthPreviousButtonPressed()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.mint)
            }
            .buttonStyle(.plain)
            Spacer()
            Label {
                Text(interactor?.dateString(from: state.selectedMonthDate) ?? "")
                    .foregroundColor(.mint)
            } icon: {
                Image(systemName: "calendar")
                    .foregroundColor(.mint)
            }
            .labelStyle(NormalLabelStyle())
            Spacer()
            Button {
                withAnimation {
                    interactor?.monthNextButtonPressed()
                }
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.mint)
            }
            .buttonStyle(.plain)
        }
    }
}
