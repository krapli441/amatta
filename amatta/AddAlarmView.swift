//
//  AddAlarmView.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import Foundation
import SwiftUI

struct AddAlarmView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var alarmName: String = ""
    @State private var selectedTime = Date()
    @State private var selectedWeekdays: [Bool] = Array(repeating: false, count: 7)
    @State private var showingAddItemView = false
    @State private var showingNewItemView = false
    @StateObject private var alarmCreationData = AlarmCreationData()
    @State private var editingItem: TemporaryItem?
    @State private var showingToast = false
    @State private var toastMessage = ""
    @State private var isAddButtonDisabled = true
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        VStack {
            AlarmHeaderView()
            ScrollView {
                VStack(spacing: 12) {
                    inputSection(title: "알림 이름", content: CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName))
                    inputSection(title: "알림 시간", content: CustomDatePicker(selection: $selectedTime))
                    daySelectionSection()
                    itemsToBringSection()
                    addItemButton()
                        .sheet(item: $editingItem) { item in
                                AddItemView(alarmCreationData: self.alarmCreationData, editingItem: item)  // 물건 편집 모드
                            }
                }
            }
            addButton()
                .disabled(isAddButtonDisabled)
                .onAppear {
                            checkAddButtonState() // View가 나타날 때 상태 검사
                        }
                        .onChange(of: alarmName) { _ in
                            checkAddButtonState() // 알림 이름이 변경될 때 상태 검사
                        }
                        .onChange(of: selectedWeekdays) { _ in
                            checkAddButtonState() // 선택된 요일이 변경될 때 상태 검사
                        }
        }
        .onTapGesture { hideKeyboard() }
    }

    private func checkAddButtonState() {
            isAddButtonDisabled = alarmName.isEmpty || !selectedWeekdays.contains(true)
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

    private func itemsToBringSection() -> some View {
        VStack(alignment: .center, spacing: 5) {  // VStack의 정렬을 .center로 변경
            SectionHeaderView(title: "챙겨야 할 것들")
            ForEach(alarmCreationData.items) { item in
                        Button(action: {
                            self.editingItem = item  // 물건을 터치하면 editingItem을 설정
                        }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)

                            if !item.containedItems.isEmpty {
                                Text(formatContainedItems(item.containedItems.map { $0.name })) // ContainedItem에서 name을 추출하여 사용
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: 350, alignment: .leading)  // HStack의 최대 너비를 무한대로 설정하여 중앙 정렬
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                .sheet(item: $editingItem) { editingItem in
                 EditItemView(alarmCreationData: self.alarmCreationData,
                              editingItem: editingItem)
                }
                .onAppear {
                    print("렌더링됨: \(item)")
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
            Text("추가")
            .foregroundColor(.white)
            .frame(maxWidth: 320)
            .padding()
            .background(isAddButtonDisabled ? Color.gray : Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
            .cornerRadius(10)
            .animation(.easeInOut, value: isAddButtonDisabled)
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
        
        let newAlarm = Alarm(context: managedObjectContext)
        newAlarm.name = alarmName
        newAlarm.alarmIdentifier = UUID().uuidString
        newAlarm.time = calendar.date(from: timeComponents)
        newAlarm.sunday = selectedWeekdays[0] // 일요일
        newAlarm.monday = selectedWeekdays[1] // 월요일
        newAlarm.tuesday = selectedWeekdays[2] // 화요일
        newAlarm.wednesday = selectedWeekdays[3] // 수요일
        newAlarm.thursday = selectedWeekdays[4] // 목요일
        newAlarm.friday = selectedWeekdays[5] // 금요일
        newAlarm.saturday = selectedWeekdays[6] // 토요일


        for temporaryItem in alarmCreationData.items {
            let newItem = Items(context: managedObjectContext)
            newItem.name = temporaryItem.name
            newItem.isContainer = temporaryItem.isContainer
            newItem.importance = temporaryItem.importance
            newItem.creationDate = temporaryItem.creationDate // 상위 아이템의 creationDate 사용

            if temporaryItem.isContainer {
                for childItem in temporaryItem.containedItems {
                    let childItemName = childItem.name
                    let childItemEntity = Items(context: managedObjectContext)
                    childItemEntity.name = childItemName
                    childItemEntity.isContainer = false // 자식 아이템은 컨테이너가 아님
                    childItemEntity.creationDate = childItem.creationDate // 하위 아이템의 creationDate 사용
                    newItem.addToChildren(childItemEntity)
                    
                    // Print the child item's creationDate here
                    print("Child Item: \(childItemName), Creation Date: \(childItemEntity.creationDate)")
                }
            }

            // Print the parent item's creationDate here
            print("Parent Item: \(temporaryItem.name), Creation Date: \(temporaryItem.creationDate)")
            
            newAlarm.addToItems(newItem)
        }


        do {
            try managedObjectContext.save()
            print("알람 저장 성공: \(newAlarm)")
            NotificationManager.shared.scheduleNotification(for: newAlarm)
            presentationMode.wrappedValue.dismiss()
        } catch let error as NSError {
            print("알람 저장 실패: \(error), \(error.userInfo)")
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func commonInputStyle(colorScheme: ColorScheme) -> some View {
        self
            .padding()
            .background(colorScheme == .dark ? Color(white: 0.2) : Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView()
    }
}

