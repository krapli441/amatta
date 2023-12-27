//
//  TemporaryItem.swift
//  amatta
//
//  Created by 박준형 on 12/25/23.
//

import Foundation

struct TemporaryItem: Identifiable {
    var id: UUID
    var name: String
    var isContainer: Bool
    var importance: Float
    var containedItems: [TemporaryContainedItem]
    var creationDate: Date

    init(id: UUID = UUID(), name: String, isContainer: Bool, importance: Float, containedItems: [TemporaryContainedItem], creationDate: Date = Date()) {
        self.id = id
        self.name = name
        self.isContainer = isContainer
        self.importance = importance
        self.containedItems = containedItems
        self.creationDate = creationDate
    }
}



struct TemporaryContainedItem {
    var name: String
    var creationDate: Date
}
