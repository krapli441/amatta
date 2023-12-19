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
    @State private var showingNewItemView = false
//    @EnvironmentObject var alarmCreationData: AlarmCreationData
    @StateObject private var alarmCreationData = AlarmCreationData()
    @State private var editingItem: TemporaryItem?

    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        VStack {
            AlarmHeaderView()
            ScrollView {
                VStack(spacing: 12) {
                    InputSection(title: "알림 이름", content: CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName))
                    InputSection(title: "알림 시간", content: CustomDatePicker(selection: $selectedTime))
                    DaySelectionSection(selectedWeekdays: $selectedWeekdays, weekdays: weekdays)
                    ItemsToBringSection(alarmCreationData: alarmCreationData, editingItem: $editingItem)
                    AddItemButton(showingNewItemView: $showingNewItemView)
                }
            }
            AddButton()
        }
        .onTapGesture { hideKeyboard() }
    }
}

private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

struct InputSection<Content: View>: View {
    let title: String
    let content: Content

    var body: some View {
        SectionHeaderView(title: title)
        content
            .frame(maxWidth: 320)
            .commonInputStyle()
    }
}

struct DaySelectionSection: View {
    @Binding var selectedWeekdays: [Bool]
    let weekdays: [String]

    var body: some View {
        SectionHeaderView(title: "요일 선택")
        HStack(spacing: -2) {
            ForEach(0..<weekdays.count, id: \.self) { index in
                DayButton(day: weekdays[index], isSelected: $selectedWeekdays[index])
            }
        }
        .frame(maxWidth: 320, maxHeight: 15)
        .commonInputStyle()
    }
}

struct ItemsToBringSection: View {
    @ObservedObject var alarmCreationData: AlarmCreationData
    @Binding var editingItem: TemporaryItem?

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            SectionHeaderView(title: "챙겨야 할 것들")
            ForEach(alarmCreationData.items) { item in
                ItemButton(item: item, editingItem: $editingItem)
            }
        }
    }
}

struct ItemButton: View {
    let item: TemporaryItem
    @Binding var editingItem: TemporaryItem?
    @EnvironmentObject var alarmCreationData: AlarmCreationData
    var body: some View {
        Button(action: { self.editingItem = item }) {
            ItemRow(item: item)
        }
        .sheet(item: $editingItem) { item in
                        EditItemView(editingItem: item)
                            .environmentObject(alarmCreationData)  // AlarmCreationData를 EnvironmentObject로 전달
                    }
    }
}

struct ItemRow: View {
    let item: TemporaryItem
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name).font(.headline)
                Text(item.containedItemsDescription).font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: 350, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
}

extension TemporaryItem {
    var containedItemsDescription: String {
        let maxDisplayCount = 2
        if containedItems.count > maxDisplayCount {
            let displayedItems = containedItems.prefix(maxDisplayCount).joined(separator: ", ")
            return "\(displayedItems) 외 \(containedItems.count - maxDisplayCount)개"
        } else {
            return containedItems.joined(separator: ", ")
        }
    }
}

struct AddItemButton: View {
    @Binding var showingNewItemView: Bool
    @EnvironmentObject var alarmCreationData: AlarmCreationData
    var body: some View {
        Button(action: { showingNewItemView = true }) {
            Label("여기를 눌러 물건 추가", systemImage: "plus")
                .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
        }
        .sheet(isPresented: $showingNewItemView) {
                        AddItemView(editingItem: nil)
                            .environmentObject(alarmCreationData)  // AlarmCreationData를 EnvironmentObject로 전달
                    }
        .frame(maxWidth: 320)
        .commonInputStyle()
    }
}

struct AddButton: View {
    var body: some View {
        Button(action: { /* 추가될 기능 */ }) {
            Text("추가").foregroundColor(.white)
        }
        .frame(maxWidth: 320)
        .padding()
        .background(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
        .cornerRadius(10)
    }
}

extension View {
    func commonInputStyle() -> some View {
        self
            .padding()
            .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
}

struct AddAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView()
    }
}


