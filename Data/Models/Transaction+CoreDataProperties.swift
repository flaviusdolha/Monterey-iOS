//
//  Transaction+CoreDataProperties.swift
//  Data
//
//  Created by Flavius Dolha on 03.01.2023.
//
//

import CoreData
import Foundation
import UIKit


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var picture: UIImage?
    @NSManaged public var price: Float

}

extension Transaction : Identifiable {

}
