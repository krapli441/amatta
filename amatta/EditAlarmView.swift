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
    @Environment(\.colorScheme) var colorScheme
    
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
            EditAlarmHeaderView()
            ScrollView {
                VStack(spacing: 12) {
                    inputSection(title: "알림 이름", content: CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName))
                    inputSection(title: "알림 시간", content: CustomDatePicker(selection: $selectedTime))
                    daySelectionSection()
                }
            }
        }
        .onAppear {
                    loadAlarmData()
                }
    }
    
    @ViewBuilder
    private func inputSection<Content: View>(title: String, content: Content) -> some View {
        SectionHeaderView(title: title)
        content
            .frame(maxWidth: 320)
            .commonInputStyle(colorScheme: colorScheme)
    }
    
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    @ViewBuilder
    private func daySelectionSection() -> some View {
        SectionHeaderView(title: "요일 선택")
        HStack(spacing: -2) {
            ForEach(0..<weekdays.count, id: \.self) { index in
                DayButton(day: weekdays[index], isSelected: $selectedWeekdays[index])
            }
        }
        .frame(maxWidth: 320, maxHeight: 15)
        .commonInputStyle(colorScheme: colorScheme)
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
        print("Items Count: \(alarm.items?.count ?? 0)")
        
        // 물건 정보 출력
               if let items = alarm.items as? Set<Items> {
                   for item in items {
                       print("Item: \(item.name ?? "Unknown"), Importance: \(item.importance), IsContainer: \(item.isContainer)")
                       if let children = item.children as? Set<Items>, !children.isEmpty {
                           for child in children {
                               print("Child Item: \(child.name ?? "Unknown")")
                           }
                       }
                   }
               }
        
     }
    
}

struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        EditAlarmView()
    }
}
