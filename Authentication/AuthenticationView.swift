import Design
import SwiftUI

// MARK: - AuthenticationView

public struct AuthenticationView: View {
    
    enum Field: Hashable {
        case first
        case second
        case third
        case fourth
    }
    
    // MARK: - Properties

    var interactor: AuthenticationInteractor?
    @ObservedObject var state: AuthenticationState
    @FocusState var activeField: Field?
    
    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack {
                Spacer()
                if state.type != .change {
                    title
                }
                switch state.type {
                case .login: authenticateTitle
                case .register: registerTitle
                case .change: authenticateTitle
                        .padding(.top, 32)
                }
                codeFieldView
                authenticateButton
                HStack {
                    Spacer()
                }
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .onChange(of: state.codeFieldInputs) { newValue in
            codeCondition(value: newValue)
            state.inputError = false
        }
        .onTapGesture {
            activeField = nil
        }
        .onAppear {
            interactor?.onAppear()
        }
    }
    
    private func codeCondition(value: [String]) {
        for i in 0..<3 {
            if value[i].count == 1 && activeStateForIndex(i) == activeField {
                activeField = activeStateForIndex(i + 1)
            }
        }
        
        for i in 1...3 {
            if value[i].isEmpty && !value[i - 1].isEmpty {
                activeField = activeStateForIndex(i - 1)
            }
        }
        
        for i in 0..<4 {
            if value[i].count > 1 {
                state.codeFieldInputs[i] = String(value[i].last!)
            }
        }
    }
    
    @ViewBuilder
    private var codeFieldView: some View {
        HStack(spacing: 14) {
            ForEach(0..<4, id: \.self) { index in
                VStack(spacing: 8) {
                    TextField("", text: $state.codeFieldInputs[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField, equals: activeStateForIndex(index))
                        .tint(.mint)
                        .foregroundColor(state.inputError ? .red : .mint)
                        .fontWeight(.semibold)
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(state.inputError ? .red : (activeField == activeStateForIndex(index) ? .mint : .gray.opacity(0.3)))
                        .frame(height: 2)
                }
                .frame(width: 40)
            }
        }
        .padding()
    }
    
    private var title: some View {
        HStack {
            Spacer()
            Text("Monterey")
                .font(.largeTitle)
                .foregroundColor(.mint)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.top, 32)
        .padding()
    }
    
    private var authenticateButton: some View {
        Button {
            interactor?.onAuthenticateButtonPressed()
        } label: {
            Label {
                Text(state.authenticateButtonText)
                    .fontWeight(.semibold)
                    .foregroundColor(state.isValid ? .white : .white.opacity(0.5))
            } icon: {
                Image(systemName: "arrow.right")
                    .foregroundColor(state.isValid ? .white : .white.opacity(0.5))
            }
            .labelStyle(RightImageLabelStyle())
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(state.isValid ? Color.mint : Color.mint.opacity(0.4))
            )
        }
        .disabled(!state.isValid)
        .padding()
    }
    
    private var registerTitle: some View {
        VStack {
            HStack {
                Spacer()
                Text("Welcome to Monterey!\nStart off by setting up your Passcode.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            HStack {
                Spacer()
                Label {
                    Text("This will help you protect your personal data from unwanted events.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                } icon: {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .labelStyle(SmallLabelStyle())
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding()
    }
    
    private var authenticateTitle: some View {
        VStack {
            HStack {
                Spacer()
                Text("Enter your \(state.type == .change ? "new " : "")Passcode".localized + ":")
                Spacer()
            }
        }
        .padding()
    }

    private func activeStateForIndex(_ index: Int) -> Field {
        switch index {
        case 0: return .first
        case 1: return .second
        case 2: return .third
        default: return .fourth
        }
    }
}
