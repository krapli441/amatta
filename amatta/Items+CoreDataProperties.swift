//
//  Items+CoreDataProperties.swift
//  amatta
//
//  Created by 박준형 on 12/20/23.
//
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged public var importance: Float
    @NSManaged public var isContainer: Bool
    @NSManaged public var name: String?
    @NSManaged public var alarm: Alarm?
    @NSManaged public var children: NSSet?
    @NSManaged public var parent: Items?

}

// MARK: Generated accessors for children
extension Items {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Items)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Items)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

extension Items : Identifiable {

}
