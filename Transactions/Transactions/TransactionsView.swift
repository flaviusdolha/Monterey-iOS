import Core
import Design
import Domain
import SwiftUI

// MARK: - TransactionsView

public struct TransactionsView: View {
    
    // MARK: - Properties

    var interactor: TransactionsInteractor?
    @ObservedObject var state: TransactionsState
    @ObservedObject var router: TransactionsRouter
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: router.binding) {
            ZStack {
                VStack {
                    HStack {
                        HStack {
                            Button {
                                withAnimation {
                                    interactor?.monthPreviousButtonPressed()
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.mint)
                            }
                            Spacer()
                            Label {
                                Text(interactor?.dateString(from: state.selectedMonthDate) ?? "")
                                    .foregroundColor(.mint)
                            } icon: {
                                Image(systemName: "calendar")
                                    .foregroundColor(.mint)
                            }
                            Spacer()
                            Button {
                                withAnimation {
                                    interactor?.monthNextButtonPressed()
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.mint)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                        .padding(.bottom, 4)
                    }
                        .background(Color.white)
                    if state.currentTransactions.isEmpty {
                        Spacer()
                        Text("There are currently no transactions for the selected time period.\n\nStart by adding one.".localized)
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                        Spacer()
                    } else {
                        VStack {
                            List {
                                HStack {
                                    Text("\("Total".localized): " + String(state.currentTransactions.totalPrice) + " " + "currency".localized)
                                        .font(.headline)
                                    Spacer()
                                }
                                ForEach(state.currentTransactions) { transactionCategory in
                                    Section {
                                        transactionCategoryView(transactionCategory)
                                        if transactionCategory.isExpanded {
                                            ForEach(transactionCategory.transactions) { transaction in
                                                transactionItem(transaction)
                                            }
                                        }
                                    }
                                }
                            }
                            .listStyle(.insetGrouped)
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        addFloatingButton
                    }
                }
            }
            .montereyNavBar()
            .montereyTabBar()
            .navigationTitle("Summary".localized)
            .toolbar {
                Button("Add".localized) {
                    interactor?.addButtonPressed()
                }
            }
            .navigationDestination(for: TransactionsRoute.self) { route in
                router.view(for: route)
            }
            .onAppear {
                interactor?.onAppear()
            }
        }
    }
    
    private var addFloatingButton: some View {
        Button {
            interactor?.addButtonPressed()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.mint)
                    .frame(width: 64, height: 64)
                Image(systemName: "note.text.badge.plus")
                    .foregroundColor(.white)
                    .font(.system(size: 28))
            }
        }
        .padding()
    }
    
    private func transactionCategoryView(_ transactionCategory: TransactionCategory) -> some View {
        HStack {
            ZStack {
                GeometryReader { reader in
                    Rectangle()
                        .foregroundColor(transactionCategory.category.color.opacity(0.20))
                        .frame(width: reader.size.width * CGFloat(transactionCategory.transactions.totalPrice / state.currentTransactions.totalPrice), height: 24)
                }
                    .offset(y: 6)
                HStack {
                    Text(transactionCategory.category.emoji + " " + transactionCategory.category.rawValue.capitalized)
                    Spacer()
                    Text(String(transactionCategory.transactions.totalPrice) + " " + "currency".localized)
                        .foregroundColor(.gray)
                }
            }
            Button {
                withAnimation {
                    interactor?.transactionCategoryPressed(transactionCategory)
                }
            } label: {
                Image(systemName: transactionCategory.isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(transactionCategory.category.color)
            }
        }
    }
    
    private func transactionItem(_ transaction: Domain.Transaction) -> some View {
        HStack {
            Text(transaction.note ?? "")
                .font(.callout)
            Spacer()
            Text(String(transaction.price) + " \("currency".localized)")
                .font(.callout)
                .foregroundColor(.gray)
            Image(systemName: "arrow.right")
                .foregroundColor(.gray)
        }
        .onTapGesture {
            interactor?.transactionSelected(transaction)
        }
    }
}
