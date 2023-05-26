//
//  DomainTests.swift
//  DomainTests
//
//  Created by Flavius Dolha on 25.05.2023.
//

@testable import Domain
import XCTest

final class DomainTests: XCTestCase {
    
    private var storageProvider: StorageProvider!

    override func setUp() {
        storageProvider = StorageProvider.createTemporaryStore()
    }

    override func tearDown() {
        storageProvider = nil
    }
    
    func testAddTransaction() {
        // Act
        storageProvider.saveTransaction(
            note: "Gas",
            date: .now,
            price: 100,
            category: ExpenseCategory.car.rawValue,
            picture: nil
        )
        
        // Assert
        XCTAssertEqual(storageProvider.getTransactions().count, 1)
    }
    
    func testGetTransactions() {
        // Arrange
        storageProvider.saveTransaction(note: "Gas", date: .now, price: 100, category: ExpenseCategory.car.rawValue, picture: nil)
        storageProvider.saveTransaction(note: "Rent", date: .now, price: 250, category: ExpenseCategory.home.rawValue, picture: nil)
        storageProvider.saveTransaction(note: "Groceries", date: .now, price: 40, category: ExpenseCategory.food.rawValue, picture: nil)
        
        // Act
        let transactions = storageProvider.getTransactions()
        
        // Assert
        XCTAssertEqual(transactions.count, 3)
    }
    
    func testDeleteTransaction() {
        // Arrange
        storageProvider.saveTransaction(note: "Gas", date: .now, price: 100, category: ExpenseCategory.car.rawValue, picture: nil)
        let transactions = storageProvider.getTransactions()
        XCTAssertEqual(transactions.count, 1)
        
        // Act
        storageProvider.deleteTransaction(transactions[0])
        
        // Assert
        XCTAssertEqual(storageProvider.getTransactions().count, 0)
    }
    
    func testUpdateTransaction() {
        // Arrange
        storageProvider.saveTransaction(note: "Gas", date: .now, price: 100, category: ExpenseCategory.car.rawValue, picture: nil)
        let transaction = storageProvider.getTransactions()[0]
        XCTAssertEqual(transaction.price, 100)
        
        // Act
        storageProvider.updateTransaction(transaction, note: transaction.note!, date: transaction.date!, price: 125, category: transaction.category!, picture: transaction.picture)
        
        // Assert
        XCTAssertEqual(storageProvider.getTransactions()[0].price, 125)
    }
    
    func testAddIncome() {
        // Act
        storageProvider.saveIncome(date: .now, value: 100, category: IncomeCategory.salary.rawValue)
        
        // Assert
        XCTAssertEqual(storageProvider.getIncomes().count, 1)
    }
    
    func testGetIncomes() {
        // Arrange
        storageProvider.saveIncome(date: .now, value: 100, category: IncomeCategory.salary.rawValue)
        storageProvider.saveIncome(date: .now, value: 120, category: IncomeCategory.gifts.rawValue)
        storageProvider.saveIncome(date: .now, value: 110, category: IncomeCategory.business.rawValue)
        
        // Act
        let incomes = storageProvider.getIncomes()
        
        // Assert
        XCTAssertEqual(incomes.count, 3)
    }
    
    func testDeleteIncome() {
        // Arrange
        storageProvider.saveIncome(date: .now, value: 100, category: IncomeCategory.salary.rawValue)
        let incomes = storageProvider.getIncomes()
        XCTAssertEqual(incomes.count, 1)
        
        // Act
        storageProvider.deleteIncome(incomes[0])
        
        // Assert
        XCTAssertEqual(storageProvider.getIncomes().count, 0)
    }
    
    func testUpdateIncome() {
        // Arrange
        storageProvider.saveIncome(date: .now, value: 100, category: IncomeCategory.salary.rawValue)
        let income = storageProvider.getIncomes()[0]
        XCTAssertEqual(income.value, 100)
        
        // Act
        storageProvider.updateIncome(income, date: income.date!, value: 125, category: income.category!)
        
        // Assert
        XCTAssertEqual(storageProvider.getIncomes()[0].value, 125)
    }
    
    func testAddBudget() {
        // Act
        storageProvider.saveBudget(category: ExpenseCategory.car.rawValue, amount: 100)
        
        // Assert
        XCTAssertEqual(storageProvider.getBudgets().count, 1)
    }
    
    func testGetBudgets() {
        // Arrange
        storageProvider.saveBudget(category: ExpenseCategory.car.rawValue, amount: 100)
        storageProvider.saveBudget(category: ExpenseCategory.home.rawValue, amount: 120)
        storageProvider.saveBudget(category: ExpenseCategory.business.rawValue, amount: 150)
        
        // Act
        let budgets = storageProvider.getBudgets()
        
        // Assert
        XCTAssertEqual(budgets.count, 3)
    }
    
    func testDeleteBudget() {
        // Arrange
        storageProvider.saveBudget(category: ExpenseCategory.car.rawValue, amount: 100)
        let budgets = storageProvider.getBudgets()
        XCTAssertEqual(budgets.count, 1)
        
        // Act
        storageProvider.deleteBudget(budgets[0])
        
        // Assert
        XCTAssertEqual(storageProvider.getBudgets().count, 0)
    }
    
    func testUpdateBudget() {
        // Arrange
        storageProvider.saveBudget(category: ExpenseCategory.car.rawValue, amount: 100)
        let budget = storageProvider.getBudgets()[0]
        XCTAssertEqual(budget.amount, 100)
        
        // Act
        storageProvider.updateBudget(budget, category: budget.category!, amount: 125)
        
        // Assert
        XCTAssertEqual(storageProvider.getBudgets()[0].amount, 125)
    }

}
