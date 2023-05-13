//
//  File.swift
//  Data
//
//  Created by Flavius Dolha on 03.01.2023.
//

import Foundation
import UIKit

// MARK: - TransactionStorage

public protocol TransactionStorage: Storage {
    func getTransactions() -> [Transaction]
    func getIncomes() -> [IncomeData]
    func getBudgets() -> [Budget]
    func saveTransaction(note: String, date: Date, price: Float, category: String, picture: UIImage?)
    func saveIncome(date: Date, value: Float, category: String)
    func saveBudget(category: String, value: Float)
    func updateTransaction(_ transaction: Transaction, note: String, date: Date, price: Float, category: String, picture: UIImage?)
    func updateIncome(_ income: IncomeData, date: Date, value: Float, category: String)
    func updateBudget(_ budget: Budget, category: String, value: Float)
    func deleteTransaction(_ transaction: Transaction)
    func deleteIncome(_ income: IncomeData)
    func deleteBudget(_ budget: Budget)
    func rollback()
    func reloadData()
}
