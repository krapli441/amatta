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
    var containedItems: [String]

    init(id: UUID = UUID(), name: String, isContainer: Bool, importance: Float, containedItems: [String]) {
        self.id = id
        self.name = name
        self.isContainer = isContainer
        self.importance = importance
        self.containedItems = containedItems
    }
}

