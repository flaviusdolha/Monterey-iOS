//
//  Budget+CoreDataProperties.swift
//  Domain
//
//  Created by Flavius Dolha on 13.05.2023.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var category: String?
    @NSManaged public var amount: Float

}

extension Budget : Identifiable {

}
