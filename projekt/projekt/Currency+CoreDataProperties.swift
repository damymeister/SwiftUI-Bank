//
//  Currency+CoreDataProperties.swift
//  projekt
//
//  Created by student on 20/06/2023.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var name: String?
    @NSManaged public var toAccount: Account?
    @NSManaged public var toPairBuy: PairValue?
    @NSManaged public var toPairSell: PairValue?

}

extension Currency : Identifiable {

}
