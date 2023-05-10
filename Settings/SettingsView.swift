import Core
import Design
import Domain
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
            List {
                Section {
                    HStack {
                        Picker("Currency".localized, selection: $state.currency) {
                            ForEach(Currency.allCases, id: \.self) { currency in
                                Text(currency.stringDescription(withFlag: true))
                            }
                        }
                    }
                } header: {
                    Text("Preferences".localized)
                }
                Section {
                    HStack {
                        Text("Change Passcode".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        interactor?.onChangePasscodePressed()
                    }
                    Toggle("Use biometric authentication", isOn: $state.usesBiometric)
                        .tint(.mint)
                } header: {
                    Text("Authentication".localized)
                }
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
