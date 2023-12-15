//
//  UserItems+CoreDataProperties.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//
//

import Foundation
import CoreData


extension UserItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserItems> {
        return NSFetchRequest<UserItems>(entityName: "UserItems")
    }

    @NSManaged public var importance: Int16
    @NSManaged public var isContainer: Bool
    @NSManaged public var name: String?
    @NSManaged public var alarm: UserAlarm?

}

extension UserItems : Identifiable {

}
