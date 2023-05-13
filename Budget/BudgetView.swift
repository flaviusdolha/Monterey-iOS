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
                    }
                }
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
}
