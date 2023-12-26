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
    @Environment(\.colorScheme) var colorScheme
    @State private var alarmName: String = ""
    @State private var selectedTime = Date()
    @State private var selectedWeekdays: [Bool] = Array(repeating: false, count: 7)
    @State private var showingAddItemView = false
    @State private var showingNewItemView = false
    @StateObject private var alarmCreationData = AlarmCreationData()
    @State private var items: [Items] = []
    @State private var selectedEditItem: EditTemporaryItem?
    @State private var showingToast = false
    @State private var toastMessage = ""
    @Environment(\.presentationMode) var presentationMode
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    
    init(alarmID: NSManagedObjectID? = nil) {
            self.alarmID = alarmID
            // 초기화 로직...
        }
    
    var body: some View {
        VStack {
            EditAlarmHeaderView()
            ScrollView {
                VStack(spacing: 12) {
                    inputSection(title: "알림 이름", content: CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName))
                    inputSection(title: "알림 시간", content: CustomDatePicker(selection: $selectedTime))
                    daySelectionSection()
                    itemsToBringSection()
                    addItemButton()
                    // EditAlarmView
                    .sheet(item: $selectedEditItem) { tempItem in
                        AlarmEditModifyItemView(
                            alarmCreationData: self.alarmCreationData,
                            editingItem: tempItem,
                            onItemUpdated: { updatedItem in
                                if let coreDataID = updatedItem.coreDataID, let index = self.items.firstIndex(where: { $0.objectID == coreDataID }) {
                                    // 변경 전 정보 출력
                                    print("변경 전: \(self.items[index])")

                                    // 기존 아이템 업데이트
                                    self.items[index].name = updatedItem.name
                                    self.items[index].isContainer = updatedItem.isContainer
                                    self.items[index].importance = updatedItem.importance

                                    // 기존 자식 아이템들 삭제
                                    if let existingChildren = self.items[index].children as? Set<Items> {
                                        existingChildren.forEach { self.managedObjectContext.delete($0) }
                                    }

                                    // 새로운 자식 아이템들 추가
                                    updatedItem.containedItems.forEach { itemName in
                                        let childItem = Items(context: self.managedObjectContext)
                                        childItem.name = itemName
                                        self.items[index].addToChildren(childItem)
                                    }

                                    // 변경 사항 출력
                                    print("변경 후 - 이름: \(self.items[index].name ?? ""), 담김 여부: \(self.items[index].isContainer), 중요도: \(self.items[index].importance)")

                                    // 'items' 배열이 업데이트되면 뷰를 다시 그리도록 SwiftUI에 알립니다.
                                    self.items = self.items
                                }
                            }
                        )
                    }


                }
            }
            addButton()
        }
        .onTapGesture { hideKeyboard() }
        .onAppear {
                loadAlarmData()
            print("알림 정보에서 가져온 물건들 : \(items)")
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
    
    private func loadAlarmData() {
        guard let alarmID = alarmID,
              let alarm = managedObjectContext.object(with: alarmID) as? Alarm else {
            print("Alarm not found")
            return
        }
        if let alarmItems = alarm.items as? Set<Items> {
                    self.items = Array(alarmItems)
                }

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
 

        // 콘솔에 정보 출력
        print("Alarm Name: \(alarmName)")
        print("Selected Time: \(selectedTime)")
        print("Selected Weekdays: \(selectedWeekdays)")

        // Items 관련 정보 출력
        if let items = alarm.items as? Set<Items> {
            for item in items {
                print("Item Name: \(item.name ?? "Unknown")")
                print("Is Container: \(item.isContainer)")
                print("Importance: \(item.importance)")
                // 연관된 자식 아이템들에 대한 정보
                if let children = item.children as? Set<Items> {
                    for child in children {
                        print("Child Item Name: \(child.name ?? "Unknown")")
                    }
                }
            }
        }
    }



    private func itemsToBringSection() -> some View {
        VStack(alignment: .center, spacing: 5) {
            SectionHeaderView(title: "챙겨야 할 것들")
            ForEach(items, id: \.self) { item in
                Button(action: {
                    // CoreData의 Items 객체를 TemporaryItem으로 변환
                    let tempItem = EditTemporaryItem(
                            coreDataID: item.objectID, // CoreData의 ID 사용
                            name: item.name ?? "",
                            isContainer: item.isContainer,
                            importance: item.importance,
                            containedItems: item.childrenArray.map { $0.name ?? "" }
                                   )
                                   self.selectedEditItem = tempItem
                               }){
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Unknown")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            if let children = item.children as? Set<Items>, !children.isEmpty {
                                Text(children.map { $0.name ?? "" }.joined(separator: ", "))
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
                    // 편집 모드나 추가 로직은 필요한 경우 구현
                }
            }
        }
    }


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
            showingNewItemView = true
        }) {
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                Text("여기를 눌러 물건 추가")
                    .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
            }
        }
        .sheet(isPresented: $showingNewItemView) {
            AddItemView(alarmCreationData: self.alarmCreationData, editingItem: nil)  // 새 물건 추가 모드
        }
        .frame(maxWidth: 320)
        .commonInputStyle(colorScheme: colorScheme)
    }

    private func addButton() -> some View {
        Button(action: saveAlarm) {
            Text("변경")
            .foregroundColor(.white)
            .frame(maxWidth: 320)
            .padding()
            .background(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
            .cornerRadius(10)
        }
    }
    
    private func saveAlarm() {
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        var timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        timeComponents.year = currentDateComponents.year
        timeComponents.month = currentDateComponents.month
        timeComponents.day = currentDateComponents.day
        timeComponents.second = 0
        
        if let alarmID = alarmID,
           let alarm = managedObjectContext.object(with: alarmID) as? Alarm {
            // 기존 알람을 찾았을 때, 해당 알람 정보를 업데이트
            alarm.name = alarmName
            alarm.time = calendar.date(from: timeComponents)
            alarm.sunday = selectedWeekdays[0]
            alarm.monday = selectedWeekdays[1]
            alarm.tuesday = selectedWeekdays[2]
            alarm.wednesday = selectedWeekdays[3]
            alarm.thursday = selectedWeekdays[4]
            alarm.friday = selectedWeekdays[5]
            alarm.saturday = selectedWeekdays[6]
            
            // 기존 알람에 연관된 아이템을 업데이트
            for item in alarm.items as? Set<Items> ?? [] {
                managedObjectContext.delete(item) // 기존 아이템 삭제
            }
            
            for temporaryItem in alarmCreationData.items {
                let newItem = Items(context: managedObjectContext)
                newItem.name = temporaryItem.name
                newItem.isContainer = temporaryItem.isContainer
                newItem.importance = temporaryItem.importance
                
                if temporaryItem.isContainer {
                    for childName in temporaryItem.containedItems {
                        let childItem = Items(context: managedObjectContext)
                        childItem.name = childName
                        childItem.isContainer = false
                        newItem.addToChildren(childItem)
                    }
                }
                
                alarm.addToItems(newItem) // 업데이트된 아이템 추가
            }
        }
        
        do {
            try managedObjectContext.save()
            if let alarm = alarm { // 옵셔널 바인딩을 사용하여 alarm을 해제
                print("알람 업데이트 성공: 이름 - \(alarm.name ?? "Unknown"), 시간 - \(alarm.time ?? Date())")
                NotificationManager.shared.scheduleNotification(for: alarm)
            } else {
                print("알람 업데이트 성공: 알람이 없습니다.") // alarm이 nil인 경우에 대한 처리
            }
            presentationMode.wrappedValue.dismiss()
        } catch let error as NSError {
            print("알람 업데이트 실패: \(error), \(error.userInfo)")
        }

    }


    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        EditAlarmView()
    }
}


