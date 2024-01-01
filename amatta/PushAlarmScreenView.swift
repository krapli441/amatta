//
//  PushAlarmScreenView.swift
//  amatta
//
//  Created by 박준형 on 1/1/24.
//

import Foundation
import SwiftUI

struct PushAlarmScreenView: View {
    @ObservedObject var alarmData: AlarmData

    var body: some View {
        VStack {
            Text("Alarm Name: \(alarmData.alarmName)")
            List(alarmData.items, id: \.self) { item in
                Text("\(item.name) (중요도: \(item.importance))")
                // 필요하다면 하위 아이템들도 여기에 표시
            }
        }
    }
}

struct PushAlarmScreenView_Previews: PreviewProvider {
    static var previews: some View {
        PushAlarmScreenView(alarmData: AlarmData())
    }
}
