//
//  EditTemporaryItem.swift
//  amatta
//
//  Created by 박준형 on 12/25/23.
//

import Foundation
import CoreData

struct EditTemporaryItem: Identifiable {
    var id: UUID
    var coreDataID: NSManagedObjectID?
    var name: String
    var isContainer: Bool
    var importance: Float
    var containedItems: [String]

    init(id: UUID = UUID(), coreDataID: NSManagedObjectID? = nil, name: String, isContainer: Bool, importance: Float, containedItems: [String]) {
        self.id = id
        self.coreDataID = coreDataID
        self.name = name
        self.isContainer = isContainer
        self.importance = importance
        self.containedItems = containedItems
    }
}

