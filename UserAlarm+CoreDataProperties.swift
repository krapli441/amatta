//
//  UserAlarm+CoreDataProperties.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//
//

import Foundation
import CoreData


extension UserAlarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAlarm> {
        return NSFetchRequest<UserAlarm>(entityName: "UserAlarm")
    }

    @NSManaged public var friday: Bool
    @NSManaged public var monday: Bool
    @NSManaged public var name: String?
    @NSManaged public var saturday: Bool
    @NSManaged public var sunday: Bool
    @NSManaged public var thursday: Bool
    @NSManaged public var time: Date?
    @NSManaged public var tuesday: Bool
    @NSManaged public var wednesday: Bool
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension UserAlarm {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: UserItems)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: UserItems)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension UserAlarm : Identifiable {

}
