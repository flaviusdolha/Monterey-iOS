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
    private var incomes: [IncomeData] = []
    private var budgets: [Budget] = []
    
    public static let shared = StorageProvider()

    // MARK: - Lifecycle
    
    private init() {
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
            rollback()
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
    
    public func getIncomes() -> [IncomeData] {
        let fetchRequest: NSFetchRequest<IncomeData> = IncomeData.fetchRequest()

        do {
            incomes = try persistentContainer.viewContext.fetch(fetchRequest)
            return incomes
        } catch {
            return []
        }
    }
    
    public func getBudgets() -> [Budget] {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()

        do {
            budgets = try persistentContainer.viewContext.fetch(fetchRequest)
            return budgets
        } catch {
            return []
        }
    }
    
    public func saveTransaction(note: String, date: Date, price: Float, category: String, picture: UIImage?) {
        let transaction = Transaction(context: persistentContainer.viewContext)
        updateTransaction(transaction, note: note, date: date, price: price, category: category, picture: picture)
    }
    
    public func saveIncome(date: Date, value: Float, category: String) {
        let income = IncomeData(context: persistentContainer.viewContext)
        updateIncome(income, date: date, value: value, category: category)
    }
    
    public func saveBudget(category: String, amount: Float) {
        let budget = Budget(context: persistentContainer.viewContext)
        updateBudget(budget, category: category, amount: amount)
    }
    
    public func updateTransaction(_ transaction: Transaction, note: String, date: Date, price: Float, category: String, picture: UIImage?) {
        transaction.note = note
        transaction.date = date
        transaction.price = price
        transaction.category = category
        transaction.picture = picture
        saveUpdates()
    }
    
    public func updateIncome(_ income: IncomeData, date: Date, value: Float, category: String) {
        income.date = date
        income.value = value
        income.category = category
        saveUpdates()
    }
    
    public func updateBudget(_ budget: Budget, category: String, amount: Float) {
        budget.category = category
        budget.amount = amount
        saveUpdates()
    }
    
    public func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)

        saveUpdates()
    }
    
    public func deleteIncome(_ income: IncomeData) {
        persistentContainer.viewContext.delete(income)
        
        saveUpdates()
    }
    
    public func deleteBudget(_ budget: Budget) {
        persistentContainer.viewContext.delete(budget)
        
        saveUpdates()
    }
    
    public func rollback() {
        persistentContainer.viewContext.rollback()
    }
}
