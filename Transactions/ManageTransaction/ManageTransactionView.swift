import Design
import Domain
import PhotosUI
import SwiftUI

// MARK: - ManageTransactionView

struct ManageTransactionView: View {
    
    // MARK: - Properties

    var interactor: ManageTransactionInteractor?
    @ObservedObject var state: ManageTransactionState
    @State private var isShowingDeleteConfirmation = false
    @State private var isShowingDatePicker = false
    @State private var isShowingImagePicker = false
    @State private var isShowingFullScreenPicture = false
    @State private var picture: UIImage?
    @State private var price: Float = .zero
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            amountTextField
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 4)
            descriptionTextField
                .padding(.horizontal)
                .padding(.vertical, 4)
            categoryPicker
                .padding(.horizontal)
                .padding(.vertical, 4)
            datePicker
                .padding(.horizontal)
                .padding(.vertical, 4)
            photoView
                .padding(.horizontal)
                .padding(.top, 4)
                .padding(.bottom, state.type == .add ? 16 : 4)
            if !(state.type == .add) {
                deleteTransactionButton
                    .padding(.horizontal)
                    .padding(.top, 4)
                    .padding(.bottom, 16)
            }
        }
            .montereyTabBar()
            .montereyNavBar()
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(actionButtonTitle) {
                    interactor?.actionButtonPressed(price: price, picture: picture)
                }
            }
            .alert("Are you sure?".localized, isPresented: $isShowingDeleteConfirmation, actions: {
                Button("No".localized, role: .cancel) {
                    isShowingDeleteConfirmation = false
                }
                Button("Yes".localized, role: .destructive) {
                    interactor?.confirmDeleteTransaction()
                }
            }, message: {
                Text("You are about to delete this transaction. The action can't be undone.".localized)
            })
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { photo in
                    picture = photo
                }
            }
            .sheet(isPresented: $isShowingFullScreenPicture) {
                fullScreenPicture
            }
            .onAppear() {
                interactor?.onAppear({ picture in
                    self.picture = picture
                }, { price in
                    self.price = price
                })
            }
    }
    
    private var amountTextField: some View {
        HStack {
            TextField("Amount".localized, value: $price, formatter: formatter)
                .font(.system(size: 22))
                .keyboardType(.decimalPad)
            Text(state.currency.symbol)
                .font(.system(size: 22))
                .foregroundColor(.mint)
                .fontWeight(.bold)
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
    
    private var descriptionTextField: some View {
        TextField("Description".localized, text: $state.transactionData.note)
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
    
    private var deleteTransactionButton: some View {
        Button("Delete Transaction".localized) {
            isShowingDeleteConfirmation = true
        }
        .foregroundColor(.red)
    }
    
    private var categoryPicker: some View {
        HStack(spacing: -8) {
            Text("Category".localized + ": ")
            Picker("Category".localized, selection: $state.transactionData.category) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    Text(category.emoji + " " + category.rawValue.capitalized.localized)
                }
            }
            Spacer()
        }
        .padding(.horizontal , 12)
        .padding(.vertical, 6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
    
    private var datePicker: some View {
        VStack {
            HStack {
                Text("Date".localized + ": ")
                Button(state.transactionData.date.formatted(date: .long, time: .omitted)) {
                    isShowingDatePicker = true
                }
                .padding(.leading, -4)
                Spacer()
                if isShowingDatePicker {
                    Button("Close".localized) {
                        isShowingDatePicker = false
                    }
                    .foregroundColor(.red)
                }
            }
            if isShowingDatePicker {
                DatePicker("Date cho", selection: $state.transactionData.date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding(-8)
            }
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
    
    private var photoView: some View {
        VStack {
            if let picture = self.picture {
                HStack {
                    Spacer()
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: picture)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                isShowingFullScreenPicture = true
                            }
                        Button {
                            withAnimation {
                                self.picture = nil
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(.mint)
                                    .frame(width: 28, height: 28)
                                Image(systemName: "xmark")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(8)
                    }
                    Spacer()
                }
            } else {
                HStack {
                    Button {
                        isShowingImagePicker = true
                    } label: {
                        Label("Add Image".localized, systemImage: "camera.fill")
                    }
                    Spacer()
                }
            }
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
    
    private var fullScreenPicture: some View {
        VStack {
            Spacer()
            if let picture = picture {
                HStack {
                    Spacer()
                    Image(uiImage: picture)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
            }
            Spacer()
        }
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .onTapGesture {
                            isShowingFullScreenPicture = false
                        }
                }
                .padding()
                Spacer()
            }
        }
        .background(Color.black)
    }
    
    private var actionButtonTitle: String {
        switch state.type {
        case .add: return "Add".localized
        case .edit: return "Save".localized
        }
    }
    
    private var navigationTitle: String {
        switch state.type {
        case .add: return "Add Transaction".localized
        case .edit: return "Edit Transaction".localized
        }
    }
}
