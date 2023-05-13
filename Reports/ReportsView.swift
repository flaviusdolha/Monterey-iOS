import Charts
import Core
import Design
import Domain
import SwiftUI

// MARK: - ReportsView

public struct ReportsView: View {
    
    // MARK: - Properties

    var interactor: ReportsInteractor?
    @ObservedObject var state: ReportsState
    @ObservedObject var router: ReportsRouter
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: router.binding) {
            List {
                Section {
                    headline
                }
                Section {
                    reportsPeriod
                    if state.periodType == .monthly {
                        Picker("Month", selection: $state.selectedMonth) {
                            ForEach(1...12, id: \.self) { month in
                                Text(month.monthString ?? "")
                            }
                        }
                    }
                    Picker("Year", selection: $state.selectedYear) {
                        ForEach(2022...2027, id: \.self) { year in
                            Text(String(year))
                        }
                    }
                } header: {
                    Text("Period")
                }
                Section {
                    generateReportsButton
                }
                if state.showCharts {
                    if !state.expenses.isEmpty {
                        expensesBarChart
                    } else {
                        if state.periodType == .monthly {
                            Text("There are no transactions for the selected time period.")
                                .foregroundColor(.gray)
                        }
                    }
                    if state.periodType == .yearly {
                        if !state.expensesByMonth.isEmpty {
                            monthlyExpensesLineChart
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .montereyNavBar()
            .montereyTabBar()
            .navigationTitle("Reports".localized)
            .navigationDestination(for: ReportsRoute.self) { route in
                router.view(for: route)
            }
            .tint(.mint)
            .onAppear {
                interactor?.onAppear()
            }
        }
    }
    
    private var headline: some View {
        HStack {
            Image(systemName: "chart.xyaxis.line")
                .foregroundColor(.mint)
                .font(.system(size: 64))
            VStack(spacing: 4) {
                Spacer()
                HStack {
                    Text("Financial Reports")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack {
                    Text("Analyze your spending habits with our useful financial reporting tools.")
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
    
    private var generateReportsButton: some View {
        HStack {
            Spacer()
            Button {
                interactor?.onGenerateReportsButtonPressed()
            } label: {
                Text("Generate Reports")
                    .foregroundColor(.mint)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
    }
    
    private var expensesBarChart: some View {
        Section {
            Chart(state.expenses) {
                if let expenseCategory = ExpenseCategory(rawValue: $0.category) {
                    BarMark(
                        x: .value("Category", state.expenses.count > 6 ? expenseCategory.emoji : $0.category.capitalized),
                        y: .value("Value", $0.totalValue)
                    )
                    .foregroundStyle(Color.mint.gradient)
                    .cornerRadius(4)
                }
            }
            .chartYAxisLabel("Total price (\(state.currency.symbol))")
            .chartXAxisLabel(state.periodString)
            .padding(.vertical)
        } header: {
            Text("Expenses Bar Chart By Category".localized)
        }
    }
    
    private var monthlyExpensesLineChart: some View {
        Section {
            Chart(state.expensesByMonth) {
                LineMark(
                    x: .value("Month", $0.date, unit: .month),
                    y: .value("Value", $0.totalValue)
                )
            }
            .chartYAxisLabel("Total price (\(state.currency.symbol))")
            .chartXAxisLabel(String(state.selectedYear))
            .chartXAxis {
                AxisMarks(values: state.expensesByMonth.map { $0.date }) { date in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month(.narrow), centered: true)
                }
            }
            .padding(.vertical)
        } header: {
            Text("Expenses Line Chart By Month".localized)
        }
    }
        
    private var reportsPeriod: some View {
        Picker("Reports Period", selection: $state.periodType) {
            Text("Monthly".localized).tag(PeriodType.monthly)
            Text("Yearly".localized).tag(PeriodType.yearly)
        }
        .pickerStyle(.segmented)
        .onAppear() {
            UISegmentedControl.appearance().selectedSegmentTintColor = .systemMint
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        }
    }
}

