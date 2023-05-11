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
                    Picker("Month", selection: $state.selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(month.monthString ?? "")
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
                    HStack {
                        Spacer()
                        Button {
                            return
                        } label: {
                            Text("Generate Reports")
                                .foregroundColor(.mint)
                                .fontWeight(.semibold)
                        }

                        Spacer()
                    }
                }
            }
            .montereyNavBar()
            .montereyTabBar()
            .navigationTitle("Reports".localized)
            .navigationDestination(for: ReportsRoute.self) { route in
                router.view(for: route)
            }
            .tint(.mint)
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
}

