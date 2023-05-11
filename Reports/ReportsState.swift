import Combine

// MARK: - ReportsState

final class ReportsState: ObservableObject {
    @Published var selectedMonth: Int = 1
    @Published var selectedYear: Int = 2023
}
