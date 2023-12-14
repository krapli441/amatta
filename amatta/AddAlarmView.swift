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
    let weekdays = ["일","월", "화", "수", "목", "금", "토"]

    var body: some View {
            VStack {
                AlarmHeaderView()
                VStack(spacing: 20) {
                    SectionHeaderView(title: "알림 이름")
                    CustomTextField(placeholder: "이름을 입력해주세요.", text: $alarmName)
                        .frame(maxWidth: 350)

                    SectionHeaderView(title: "알림 시간")
                    CustomDatePicker(selection: $selectedTime)

                    SectionHeaderView(title: "요일 선택")
                    HStack(spacing: -2) {
                        ForEach(0..<weekdays.count, id: \.self) { index in
                            DayButton(day: weekdays[index], isSelected: $selectedWeekdays[index])
                        }
                    }
                    .frame(maxWidth: 350) // 박스의 너비를 350으로 설정
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )

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
// 프리뷰
struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView()
    }
}
