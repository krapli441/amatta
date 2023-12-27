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
    @Environment(\.presentationMode) var presentationMode
    let alarmID: NSManagedObjectID?
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var alarm: Alarm?
    @State private var alarmName: String = ""
    @State private var selectedTime = Date()
    @State private var selectedWeekdays: [Bool] = Array(repeating: false, count: 7)
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
            VStack {
                EditAlarmHeaderView()
                ScrollView {
                    VStack(spacing: 12) {
                        inputSection(title: "알림 이름", content: CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName))
                        inputSection(title: "알림 시간", content: CustomDatePicker(selection: $selectedTime))
                        daySelectionSection()
                        itemsToBringSection()
                    }
                }
                HStack {
                    deleteButton()
                    updateButton()
                }
            }
            .onAppear {
                loadAlarmData()
            }
            .onTapGesture { hideKeyboard() }
        }
    private func deleteButton() -> some View {
        Button(action: {
            // 삭제 버튼 액션
        }) {
            Text("삭제")
                .foregroundColor(.white)
                .frame(width: 140)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
        }
    }

    // 업데이트(변경) 버튼
    private func updateButton() -> some View {
        Button(action: {
            updateAlarm()
//            alarmDataModel.fetchAlarms()
        }) {
            Text("변경")
                .foregroundColor(.white)
                .frame(width: 140)
                .padding()
                .background(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                .cornerRadius(10)
        }
    }
    
    // 알람 업데이트 로직
    private func updateAlarm() {
        guard let alarmID = alarmID, let alarm = managedObjectContext.object(with: alarmID) as? Alarm else {
            print("Alarm not found")
            return
        }
        
        // 기존 알림 삭제
        if let identifier = alarm.alarmIdentifier {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            print("알림 삭제됨: \(identifier)")
        }

        // 알람 정보 업데이트
        alarm.name = alarmName
        alarm.time = selectedTime
        alarm.sunday = selectedWeekdays[0]
        alarm.monday = selectedWeekdays[1]
        alarm.tuesday = selectedWeekdays[2]
        alarm.wednesday = selectedWeekdays[3]
        alarm.thursday = selectedWeekdays[4]
        alarm.friday = selectedWeekdays[5]
        alarm.saturday = selectedWeekdays[6]

        // CoreData 저장 및 알림 재스케줄링
        do {
            try managedObjectContext.save()
            NotificationManager.shared.scheduleNotification(for: alarm)
            print("알림 업데이트됨: \(alarm.alarmIdentifier ?? "Unknown Identifier")")
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("알람 업데이트 실패: \(error)")
        }
    }

    
    @ViewBuilder
    private func inputSection<Content: View>(title: String, content: Content) -> some View {
        SectionHeaderView(title: title)
        content
            .frame(maxWidth: 320)
            .commonInputStyle(colorScheme: colorScheme)
    }
    

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
    
    @ViewBuilder
    private func itemsToBringSection() -> some View {
        VStack(alignment: .center, spacing: 5) {
            SectionHeaderView(title: "챙겨야 할 것들")
            if let items = alarm?.items as? Set<Items>, !items.isEmpty {
                ForEach(Array(items), id: \.self) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Unknown")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)

                            if let children = item.children as? Set<Items>, !children.isEmpty {
                                Text(formatContainedItems(children.map { $0.name ?? "" }))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: 350, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
            } else {
                Text("물건이 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    // 물건 목록을 포맷팅하는 함수
    private func formatContainedItems(_ items: [String]) -> String {
        let maxDisplayCount = 2
        if items.count > maxDisplayCount {
            let displayedItems = items.prefix(maxDisplayCount).joined(separator: ", ")
            return "\(displayedItems) 외 \(items.count - maxDisplayCount)개"
        } else {
            return items.joined(separator: ", ")
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
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        // 더미 Context와 AlarmDataModel 생성
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let alarmDataModel = AlarmDataModel(context: context)

        EditAlarmView(alarmID: nil)
    }
}

