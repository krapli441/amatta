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
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
            VStack {
                AlarmHeaderView()

                VStack(spacing: 20) {
                    SectionHeaderView(title: "알림 이름")
                    CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName)

                    SectionHeaderView(title: "알림 시간")
                    CustomDatePicker(selection: $selectedTime)

                    SectionHeaderView(title: "요일 선택")
                    HStack {
                        ForEach(0..<weekdays.count, id: \.self) { index in
                            DayButton(day: weekdays[index], isSelected: $selectedWeekdays[index])
                        }
                    }

                    SectionHeaderView(title: "챙겨야 할 소지품")
                    Button(action: {
                        // 소지품 추가 기능
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("여기를 눌러 소지품 추가")
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct SectionHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer() // 이 Spacer가 텍스트를 왼쪽에 정렬시킴
        }
        .padding(.vertical, 5)
        .padding(.leading, 25) // 왼쪽 패딩 추가
    }
}

struct AlarmHeaderView: View {
    var body: some View {
        HStack {
            Text("알림 추가")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                .padding(.leading, 40)
            Spacer()
        }
        .padding(.top, 20)
    }
}


struct DayButton: View {
    var day: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            withAnimation {
                isSelected.toggle()
            }
        }) {
            Text(day)
                .foregroundColor(isSelected ? .white : .blue)
                .padding()
                .font(.system(size: 14))
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 1)
                )
        }
    }
}

struct CustomDatePicker: UIViewRepresentable {
    @Binding var selection: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels // 다이얼 스타일 지정
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = self.selection
    }
}


// 프리뷰
struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView()
    }
}
