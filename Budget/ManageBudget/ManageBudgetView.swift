import SwiftUI

// MARK: - ManageBudgetView

struct ManageBudgetView: View {
    
    // MARK: - Properties

    var interactor: ManageBudgetInteractor?
    @ObservedObject var state: ManageBudgetState
    
    // MARK: - Body

    var body: some View {
        Text("View")
    }
}
