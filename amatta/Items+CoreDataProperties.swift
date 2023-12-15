//
//  Items+CoreDataProperties.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged public var importance: Int16
    @NSManaged public var isContainer: Bool
    @NSManaged public var name: String?
    @NSManaged public var alarm: Alarm?

}

extension Items : Identifiable {

}
