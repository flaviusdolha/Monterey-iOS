import SwiftUI

// MARK: - MainAssembly

public final class MainAssembly {
    
    // MARK: - Lifecycle
    
    public init() {}

    // MARK: - MainView
    
    public func mainView() -> MainView {
        let interactor = MainInteractorLive()
        let view = MainView(interactor: interactor, state: interactor.state)
        return view
    }
}
