//
//  Account+CoreDataProperties.swift
//  projekt
//
//  Created by student on 20/06/2023.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var amount: Float
    @NSManaged public var currency: String?
    @NSManaged public var user: String?
    @NSManaged public var toCurrency: Currency?
    @NSManaged public var toUser: User?

}

extension Account : Identifiable {

}
