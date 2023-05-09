import Core
import SwiftUI

// MARK: - MainView

public struct MainView: View {

    // MARK: - Properties

    var interactor: MainInteractor?
    @ObservedObject var state: MainState

    // MARK: - Body

    public var body: some View {
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
            interactor?.settingsView
                .tabItem {
                    Label("Settings".localized, systemImage: "gearshape.fill")
                }
                .tag(MainRoute.settings)
        }
        .tint(.mint)
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
