//
//  StorageProvider.swift
//  Data
//
//  Created by Flavius Dolha on 02.12.2022.
//

import CoreData
import UIKit

// MARK: - PersitentContainer

public class PersistentContainer: NSPersistentContainer {}

// MARK: - Storage

public protocol Storage {
    func saveUpdates()
}

// MARK: - StorageProvider

public class StorageProvider {

    // MARK: - Private Properties

    private let persistentContainer: PersistentContainer
    private var transactions: [Transaction] = []

    // MARK: - Lifecycle
    
    public init() {
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        persistentContainer = PersistentContainer(name: "MontereyModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print(error)
            }
        }
    }
}

// MARK: - StorageProvider Storage Extension

extension StorageProvider: Storage {
    public func saveUpdates() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
}

// MARK: - StorageProvider TransactionStorage Extension

extension StorageProvider: TransactionStorage {
    public func getTransactions() -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()

        do {
            transactions = try persistentContainer.viewContext.fetch(fetchRequest)
            return transactions
        } catch {
            return []
        }
    }
    
    public func saveTransaction(note: String, date: Date, price: Float, category: String, picture: UIImage?) {
        let transaction = Transaction(context: persistentContainer.viewContext)
        updateTransaction(transaction, note: note, date: date, price: price, category: category, picture: picture)
    }
    
    public func updateTransaction(_ transaction: Transaction, note: String, date: Date, price: Float, category: String, picture: UIImage?) {
        transaction.note = note
        transaction.date = date
        transaction.price = price
        transaction.category = category
        transaction.picture = picture
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    public func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)

        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    public func rollback() {
        persistentContainer.viewContext.rollback()
    }
}
