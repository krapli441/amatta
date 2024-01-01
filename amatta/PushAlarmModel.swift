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

    init() {
        // 기본 생성자
    }

    init(alarmName: String, items: [Item]) {
        self.alarmName = alarmName
        self.items = items
    }
}


class AlarmManager: ObservableObject {
    @Published var tappedAlarm: Bool = false
    @Published var alarmData: AlarmData?
}
