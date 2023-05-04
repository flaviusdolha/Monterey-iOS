import Combine
import SharedState
import SwiftUI

// MARK: - ScannerInteractor

protocol ScannerInteractor: AnyObject {
    var state: ScannerState { get }
    
    func didSelectPicture(_ picture: UIImage)
}

// MARK: - ScannerInteractorLive

final class ScannerInteractorLive: ScannerInteractor {
    
    // MARK: - Properties
    
    var state: ScannerState
    private let router: ScannerRouter
    private let externalRouter: PassthroughSubject<ExternalScannerRoute, Never>
    private let transactionsSharedState: TransactionsSharedState
    private let scannerService: ScannerService
    
    // MARK: - Lifecycle

    init(
        router: ScannerRouter,
        externalRouter: PassthroughSubject<ExternalScannerRoute, Never>,
        transactionsSharedState: TransactionsSharedState,
        scannerService: ScannerService
    ) {
        self.router = router
        self.externalRouter = externalRouter
        self.transactionsSharedState = transactionsSharedState
        self.scannerService = scannerService
        state = ScannerState()
    }
    
    // MARK: - Instance Methods

    func didSelectPicture(_ picture: UIImage) {
        state.isLoading = true
        scannerService.scanReceipt(picture) { [weak self] result in
            DispatchQueue.main.async {
                self?.state.isLoading = false
                switch result {
                case .success(let price):
                    self?.externalRouter.send(.transaction(price, picture))
                case .failure(let error):
                    switch error {
                    case .processing:
                        self?.state.isShowingProcessingError = true
                    case .didNotFound:
                        self?.state.isShowingDidNotFoundError = true
                    }
                }
            }
        }
    }
}
