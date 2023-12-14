//
//  AddAlarmView.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import Foundation
import SwiftUI

struct AddAlarmView: View {
    @State private var alarmName: String = ""
    @State private var selectedTime = Date()
    @State private var selectedWeekdays: [Bool] = Array(repeating: false, count: 7)
    @Environment(\.colorScheme) var colorScheme
    let weekdays = ["일","월", "화", "수", "목", "금", "토"]

    var body: some View {
        VStack {
            AlarmHeaderView()
            ScrollView {
                VStack(spacing: 12) {
                    inputSection(title: "알림 이름", content: CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName))
                    inputSection(title: "알림 시간", content: CustomDatePicker(selection: $selectedTime))
                    daySelectionSection()
                    addItemButton()
                }
            }
            addButton()
        }
        .onTapGesture { hideKeyboard() }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // 별도의 뷰나 메서드로 섹션 생성
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
        .frame(maxWidth: 320, maxHeight: 20)
    
        .commonInputStyle(colorScheme: colorScheme)
    }

    private func addItemButton() -> some View {
        Button(action: { /* 소지품 추가 기능 */ }) {
            HStack {
                Image(systemName: "plus")
                Text("여기를 눌러 소지품 추가")
            }
        }
        .frame(maxWidth: 320)
        .commonInputStyle(colorScheme: colorScheme)
    }

    private func addButton() -> some View {
        Button(action: { /* 추가될 기능 */ }) {
            Text("추가")
            .foregroundColor(.white)
            .frame(maxWidth: 320)
            .padding()
            .background(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
            .cornerRadius(10)
        }
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

    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

// 프리뷰
struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView()
    }
}
