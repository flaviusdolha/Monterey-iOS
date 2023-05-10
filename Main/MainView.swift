import Core
import SwiftUI

// MARK: - MainView

public struct MainView: View {

    // MARK: - Properties

    var interactor: MainInteractor?
    @ObservedObject var state: MainState

    // MARK: - Body

    public var body: some View {
        if state.isAuthenticated {
            TabView(selection: $state.route) {
                interactor?.transactionsView
                    .tabItem {
                        Label("Transactions".localized, systemImage: "list.bullet.rectangle")
                    }
                    .tag(MainRoute.transactions)
                interactor?.scannerView
                    .tabItem {
                        Label("Scan".localized, systemImage: "barcode.viewfinder")
                    }
                    .tag(MainRoute.scan)
                interactor?.reportsView
                    .tabItem {
                        Label("Reports".localized, systemImage: "chart.bar.xaxis")
                    }
                    .tag(MainRoute.reports)
                interactor?.settingsView
                    .tabItem {
                        Label("Settings".localized, systemImage: "gearshape.fill")
                    }
                    .tag(MainRoute.settings)
            }
            .tint(.mint)
        } else {
            interactor?.authenticationView
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView(interactor: nil, state: MainState())
                .previewLayout(.device)
        }
    }
}
