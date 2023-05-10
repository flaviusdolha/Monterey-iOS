import Combine
import Domain

// MARK: - ManageIncomeType

enum ManageIncomeType: Equatable {
    case add
    case edit(IncomeData)
}

// MARK: - ManageIncomeState

final class ManageIncomeState: ObservableObject {
    @Published var income: IncomeDataModel
    @Published var type: ManageIncomeType
    @Published var isShowingConfirmDelete: Bool = false
    @Published var currency: Currency = .usd
    
    init(income: IncomeDataModel, type: ManageIncomeType) {
        self.income = income
        self.type = type
    }
}
