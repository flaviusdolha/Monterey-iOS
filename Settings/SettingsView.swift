import Core
import Design
import SwiftUI

// MARK: - SettingsView

public struct SettingsView: View {
    
    // MARK: - Properties

    var interactor: SettingsInteractor?
    @ObservedObject var state: SettingsState
    @ObservedObject var router: SettingsRouter
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: router.binding) {
            VStack {
                Text("")
            }
            .montereyNavBar()
            .montereyTabBar()
            .navigationTitle("Settings".localized)
            .navigationDestination(for: SettingsRoute.self) { route in
                router.view(for: route)
            }
        }
    }
}
