//
//  Transaction+CoreDataProperties.swift
//  Hesabdar
//
//  Created by Pouya on 8/12/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var title: String?
    @NSManaged public var value: Float
    @NSManaged public var date: NSDate?
    @NSManaged public var tagName: String?
    @NSManaged public var accID: String?

}
