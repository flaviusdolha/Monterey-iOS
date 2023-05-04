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
    func saveTransaction(note: String, date: Date, price: Float, category: String, picture: UIImage?)
    func updateTransaction(_ transaction: Transaction, note: String, date: Date, price: Float, category: String, picture: UIImage?)
    func deleteTransaction(_ transaction: Transaction)
    func rollback()
}
