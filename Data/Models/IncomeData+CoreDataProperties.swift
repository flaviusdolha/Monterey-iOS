//
//  IncomeData+CoreDataProperties.swift
//  
//
//  Created by Flavius Dolha on 09.05.2023.
//
//

import Foundation
import CoreData


extension IncomeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IncomeData> {
        return NSFetchRequest<IncomeData>(entityName: "IncomeData")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var value: Float

}
