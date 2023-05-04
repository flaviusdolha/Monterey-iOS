import Combine
import SharedState
import SwiftUI

// MARK: - ScannerAssembly

public final class ScannerAssembly {
    
    // MARK: - Properties
    
    private let environment: ScannerEnvironment
    
    // MARK: - Lifecycle
    
    public init(transactionsSharedState: TransactionsSharedState) {
        environment = ScannerEnvironmentLive(transactionsSharedState: transactionsSharedState)
    }
    
    // MARK: - ScannerView
    
    public lazy var externalRouter: AnyPublisher<ExternalScannerRoute, Never> = {
        environment.externalRouter.eraseToAnyPublisher()
    }()
    
    public func scannerView() -> ScannerView {
        let interactor = ScannerInteractorLive(
            router: environment.router,
            externalRouter: environment.externalRouter,
            transactionsSharedState: environment.transactionsSharedState,
            scannerService: environment.scannerService
        )
        let view = ScannerView(interactor: interactor, state: interactor.state, router: environment.router)
        return view
    }
}
