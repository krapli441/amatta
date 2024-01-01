//
//  PushAlarmModel.swift
//  amatta
//
//  Created by 박준형 on 1/1/24.
//

import Foundation
import SwiftUI
import Combine

class AlarmData: ObservableObject {
    @Published var alarmName: String = ""
    @Published var items: [Item] = []

    struct Item: Hashable {
        var name: String
        var importance: Float
        var children: [Item]
    }
}

class AlarmManager: ObservableObject {
    @Published var tappedAlarm: Bool = false
    @Published var alarmData: AlarmData?
}
