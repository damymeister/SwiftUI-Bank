//
//  PairValue+CoreDataProperties.swift
//  projekt
//
//  Created by student on 20/06/2023.
//
//

import Foundation
import CoreData


extension PairValue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PairValue> {
        return NSFetchRequest<PairValue>(entityName: "PairValue")
    }

    @NSManaged public var buying_currency: String?
    @NSManaged public var selling_currency: String?
    @NSManaged public var value: Float
    @NSManaged public var buy_curr: Currency?
    @NSManaged public var sell_curr: Currency?

}

extension PairValue : Identifiable {

}
