//
//  Item.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
