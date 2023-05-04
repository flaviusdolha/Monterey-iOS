import Combine

// MARK: - ScannerState

final class ScannerState: ObservableObject {
    @Published var isLoading = false
    @Published var isShowingProcessingError = false
    @Published var isShowingDidNotFoundError = false
}
