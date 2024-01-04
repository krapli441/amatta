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
    @State private var alarmItems: [Items] = []
    @State private var showingDeleteAlert = false
    @State private var isItemDetailViewPresented = false
    @State private var isAddItemViewPresented = false
    @State private var selectedItemObjectID: NSManagedObjectID?
    @State private var isDeletedAlarm = false
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    @State private var hasChanges = false
    
    
    var body: some View {
            VStack {
                EditAlarmHeaderView(onDelete: deleteAlarm, showingDeleteAlert: $showingDeleteAlert)
                    .alert(isPresented: $showingDeleteAlert) {
                                        Alert(
                                            title: Text("알림 삭제"),
                                            message: Text("정말로 이 알림을 삭제하시겠어요?"),
                                            primaryButton: .destructive(Text("삭제")) {
                                                deleteAlarm()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                ScrollView {
                    VStack(spacing: 12) {
                        inputSection(title: "알림 이름", content: CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName))
                        inputSection(title: "알림 시간", content: CustomDatePicker(selection: $selectedTime))
                        daySelectionSection()
                        itemsToBringSection()
                    }
                }
            }
            .onAppear {
                loadAlarmData()
                print("EditAlarmView 감지함")
            }
            .onTapGesture { hideKeyboard() }
            .onDisappear { updateAlarm() }
        }
    
    // 알림 삭제 로직
    private func deleteAlarm() {
        guard let alarmID = self.alarmID, let alarmToDelete = managedObjectContext.object(with: alarmID) as? Alarm else {
            print("Alarm not found")
            return
        }

        // 각 요일에 대한 알림 식별자로 알림 삭제
        if let identifier = alarmToDelete.alarmIdentifier {
                let weekdays = [alarmToDelete.sunday, alarmToDelete.monday, alarmToDelete.tuesday, alarmToDelete.wednesday, alarmToDelete.thursday, alarmToDelete.friday, alarmToDelete.saturday]
                for (index, day) in weekdays.enumerated() where day {
                    let dayIdentifier = "alarm_\(identifier)_\(index)"
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dayIdentifier])
                    print("알림 스케줄러에서 삭제: \(dayIdentifier)")
                }
            }

        // CoreData에서 알림 삭제
        managedObjectContext.delete(alarmToDelete)
        do {
            try managedObjectContext.save()
            print("CoreData에서 알림 삭제 성공")
        } catch {
            print("CoreData에서 알림 삭제 실패: \(error)")
        }

        // 이전 화면으로 돌아가기
        isDeletedAlarm = true
        presentationMode.wrappedValue.dismiss()
    }


    // 알람 업데이트 로직
    private func updateAlarm() {
        // 알림이 삭제되었다면 업데이트 로직을 실행하지 않음
        if isDeletedAlarm {
            return
        }

        guard let alarmID = alarmID, let alarm = managedObjectContext.object(with: alarmID) as? Alarm else {
            print("Alarm not found")
            presentationMode.wrappedValue.dismiss()
            return
        }

        // 기존 알림 삭제
        if let identifier = alarm.alarmIdentifier, identifier != "Unknown Identifier" {
            let weekdays = [alarm.sunday, alarm.monday, alarm.tuesday, alarm.wednesday, alarm.thursday, alarm.friday, alarm.saturday]
            for (index, day) in weekdays.enumerated() where day {
                let dayIdentifier = "alarm_\(identifier)_\(index)"
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dayIdentifier])
                print("알림 삭제됨: \(dayIdentifier)")
            }
        } else {
            print("유효한 알림 식별자가 없습니다.")
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
        if let alarmIdentifier = alarm.alarmIdentifier, alarmIdentifier != "Unknown Identifier" {
            do {
                try managedObjectContext.save()
                NotificationManager.shared.scheduleNotification(for: alarm)
                print("알림 업데이트됨: \(alarmIdentifier)")
            } catch {
                print("알림 업데이트 실패: \(error)")
            }
        } else {
            print("알림 업데이트하지 않음: CoreData에 유효한 알림이 없습니다.")
        }

        presentationMode.wrappedValue.dismiss()
    }



    @ViewBuilder
    private func inputSection<Content: View>(title: String, content: Content) -> some View {
        SectionHeaderView(title: title)
        content
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
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
        .frame(maxWidth: UIScreen.main.bounds.width * 0.75, maxHeight: 15)
        .commonInputStyle(colorScheme: colorScheme)
    }
    
    
    @ViewBuilder
    private func itemsToBringSection() -> some View {
        VStack(alignment: .center, spacing: 5) {
            SectionHeaderView(title: "챙겨야 할 것들")
            if !alarmItems.isEmpty {
                ForEach(alarmItems, id: \.self) { item in
                    itemButton(item: item)
                }
            }
            addItemButton()
        }
        .sheet(isPresented: $isItemDetailViewPresented, onDismiss: loadItemData) {
            AlarmEditModifyItemView(itemObjectID: $selectedItemObjectID)
        }
    }


    private func itemButton(item: Items) -> some View {
        Button(action: {
            selectedItemObjectID = item.objectID
            isItemDetailViewPresented.toggle()
            print("Selected Item ObjectID in EditAlarmView: \(String(describing: selectedItemObjectID))")
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name ?? "불러오는 중..")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    if let children = item.children as? Set<Items>, !children.isEmpty {
                        let sortedChildren = children.sorted {
                            ($0.creationDate ?? Date.distantPast) < ($1.creationDate ?? Date.distantPast)
                        }
                        Text(formatContainedItems(Array(sortedChildren).map { $0.name ?? "" }))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: UIScreen.main.bounds.width * 0.83, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
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
    
    private func addItemButton() -> some View {
        Button(action: {
            isAddItemViewPresented = true
        }) {
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                Text("여기를 눌러 물건 추가")
                    .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
        .commonInputStyle(colorScheme: colorScheme)
        .sheet(isPresented: $isAddItemViewPresented, onDismiss: loadItemData) {
            AlarmEditAddItemView(alarmID: alarmID!)
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

        // 물건 정보 초기화
        if let items = alarm.items as? Set<Items> {
            self.alarmItems = Array(items).sorted {
                ($0.creationDate ?? Date.distantPast) < ($1.creationDate ?? Date.distantPast)
            }
        } else {
            self.alarmItems = []
        }

        // 로드된 데이터에 대한 정보를 콘솔에 출력
        print("Loaded Alarm Data:")
        print("Name: \(alarmName)")
        print("Time: \(selectedTime)")
        print("Weekdays: \(selectedWeekdays)")
        print("Items Count: \(alarm.items?.count ?? 0)")
    }

    
    private func loadItemData() {
        guard let alarmID = self.alarmID,
              let updatedAlarm = managedObjectContext.object(with: alarmID) as? Alarm else {
            print("Alarm not found")
            return
        }

        if let items = updatedAlarm.items as? Set<Items> {
            let sortedItems = Array(items).sorted {
                ($0.creationDate ?? Date.distantPast) < ($1.creationDate ?? Date.distantPast)
            }
            self.alarmItems.removeAll()
            self.alarmItems.append(contentsOf: sortedItems)
        } else {
            self.alarmItems = []
        }
    }


    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let alarmDataModel = AlarmDataModel(context: context)
        EditAlarmView(alarmID: nil)
    }
}

