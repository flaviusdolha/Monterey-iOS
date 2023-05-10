import Design
import Domain
import SwiftUI

// MARK: - ManageIncomeView

struct ManageIncomeView: View {
    
    // MARK: - Properties

    var interactor: ManageIncomeInteractor?
    @ObservedObject var state: ManageIncomeState
    @State private var isShowingDeleteConfirmation = false
    @State private var isShowingDatePicker = false
    
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
            datePicker
                .padding(.horizontal)
                .padding(.vertical, 4)
            if !(state.type == .add) {
                deleteIncomeButton
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
                interactor?.confirmDeleteIncome()
            }
        }, message: {
            Text("You are about to delete this income. The action can't be undone.".localized)
        })
    }
    
    private var amountTextField: some View {
        HStack {
            TextField("Amount".localized, value: $state.income.value, formatter: formatter)
                .font(.system(size: 22))
                .keyboardType(.decimalPad)
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
            Picker("Category".localized, selection: $state.income.category) {
                ForEach(IncomeCategory.allCases, id: \.self) { category in
                    Text(category.emoji + " " + category.rawValue.capitalized.localized)
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
    
    private var datePicker: some View {
        VStack {
            HStack {
                Text("Date".localized + ": ")
                Button(state.income.date.formatted(date: .long, time: .omitted)) {
                    isShowingDatePicker = true
                }
                .padding(.leading, -4)
                Spacer()
                if isShowingDatePicker {
                    Button("Close".localized) {
                        isShowingDatePicker = false
                    }
                    .foregroundColor(.red)
                }
            }
            if isShowingDatePicker {
                DatePicker("Date cho", selection: $state.income.date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding(-8)
            }
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
    
    private var deleteIncomeButton: some View {
        Button("Delete".localized + " " + "Income".localized) {
            isShowingDeleteConfirmation = true
        }
        .foregroundColor(.red)
    }
    
    private var actionButtonTitle: String {
        switch state.type {
        case .add: return "Add".localized
        case .edit: return "Save".localized
        }
    }
    
    private var navigationTitle: String {
        switch state.type {
        case .add: return "Add".localized + " " + "Income".localized
        case .edit: return "Edit".localized + " " + "Income".localized
        }
    }
}
