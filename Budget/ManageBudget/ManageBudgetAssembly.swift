import SwiftUI

// MARK: - ManageBudgetAssembly

final class ManageBudgetAssembly {
    
    // MARK: - ManageBudgetView
    
    func ManageBudgetView() -> ManageBudgetView {
        let interactor = ManageBudgetInteractorLive()
        let view = ManageBudgetView(interactor: interactor, state: interactor.state)
        return view
    }
}
