import Design
import Domain
import SwiftUI

// MARK: - ManageBudgetView

struct ManageBudgetView: View {
    
    enum Field: Hashable {
        case value
    }
    
    // MARK: - Properties

    var interactor: ManageBudgetInteractor?
    @ObservedObject var state: ManageBudgetState
    @State private var isShowingDeleteConfirmation = false
    
    @FocusState var activeField: Field?
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            amountTextField
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 4)
            categoryPicker
                .padding(.horizontal)
                .padding(.vertical, 4)
            if !(state.type == .add) {
                deleteBudgetButton
                    .padding(.horizontal)
                    .padding(.top, 4)
                    .padding(.bottom, 16)
            }
        }
        .montereyTabBar()
        .montereyNavBar()
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(actionButtonTitle) {
                interactor?.actionButtonPressed()
            }
        }
        .alert("Are you sure?".localized, isPresented: $isShowingDeleteConfirmation, actions: {
            Button("No".localized, role: .cancel) {
                isShowingDeleteConfirmation = false
            }
            Button("Yes".localized, role: .destructive) {
                interactor?.confirmDeleteBudget()
            }
        }, message: {
            Text("You are about to delete this budget. The action can't be undone.".localized)
        })
        .onTapGesture {
            activeField = nil
        }
    }
    
    private var amountTextField: some View {
        HStack {
            TextField("Amount".localized, value: $state.amount, formatter: formatter)
                .font(.system(size: 22))
                .keyboardType(.decimalPad)
                .focused($activeField, equals: .value)
            Text(state.currency.symbol)
                .font(.system(size: 22))
                .foregroundColor(.mint)
                .fontWeight(.bold)
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
    
    private var categoryPicker: some View {
        HStack(spacing: -8) {
            Text("Category".localized + ": ")
            Picker("Category".localized, selection: $state.category) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    if category == .none {
                        Text("💸 All Wallet".localized)
                    } else {
                        Text(category.emoji + " " + category.rawValue.capitalized.localized)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal , 12)
        .padding(.vertical, 6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
    
    private var deleteBudgetButton: some View {
        Button("Delete".localized + " " + "Budget".localized) {
            isShowingDeleteConfirmation = true
        }
        .foregroundColor(.red)
    }
    
    private var actionButtonTitle: String {
        switch state.type {
        case .add: return "Create".localized
        case .edit: return "Save".localized
        }
    }
    
    private var navigationTitle: String {
        switch state.type {
        case .add: return "Create".localized + " " + "Budget".localized
        case .edit: return "Edit".localized + " " + "Budget".localized
        }
    }
}
