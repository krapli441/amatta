//
//  AddAlarmView.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import Foundation
import SwiftUI
import CoreData

struct EditAlarmView: View {
    let alarmID: NSManagedObjectID?
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var alarm: Alarm?
    @State private var alarmName: String = ""
    @State private var selectedTime = Date()
    @State private var selectedWeekdays: [Bool] = Array(repeating: false, count: 7)
    
    init(alarmID: NSManagedObjectID? = nil) {
            self.alarmID = alarmID
        }
    
    var body: some View {
        VStack {
            // 이곳에 레이아웃 구성 요소 추가
            Text("Edit Alarm View")
        }
        .onAppear {
                    loadAlarmData()
                }
    }
    
    private func loadAlarmData() {
         guard let alarmID = self.alarmID,
               let alarm = managedObjectContext.object(with: alarmID) as? Alarm else {
             print("Alarm not found")
             return
         }

         // 알람 정보 초기화
         self.alarm = alarm
         alarmName = alarm.name ?? ""
         selectedTime = alarm.time ?? Date()
         selectedWeekdays = [
             alarm.sunday,
             alarm.monday,
             alarm.tuesday,
             alarm.wednesday,
             alarm.thursday,
             alarm.friday,
             alarm.saturday
         ]

         // 로드된 데이터에 대한 정보를 콘솔에 출력
         print("Loaded Alarm Data:")
         print("Name: \(alarmName)")
         print("Time: \(selectedTime)")
         print("Weekdays: \(selectedWeekdays)")
     }
    
}

struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        EditAlarmView()
    }
}
