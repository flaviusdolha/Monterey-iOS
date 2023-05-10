import Core
import Design
import Domain
import SwiftUI

// MARK: - ReportsView

public struct ReportsView: View {
    
    // MARK: - Properties

    var interactor: ReportsInteractor?
    @ObservedObject var state: ReportsState
    @ObservedObject var router: ReportsRouter
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: router.binding) {
            List {
                Text("Reports")
            }
            .montereyNavBar()
            .montereyTabBar()
            .navigationTitle("Reports".localized)
            .navigationDestination(for: ReportsRoute.self) { route in
                router.view(for: route)
            }
        }
    }
}

