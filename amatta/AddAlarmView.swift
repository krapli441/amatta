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
        NavigationView {
            Form {
                // 알림 이름 입력
                Section(header: Text("알림 이름")) {
                    TextField("알림 이름을 입력해주세요.", text: $alarmName)
                }

                Section(header: Text("알림 시간")) {
                    CustomDatePicker(selection: $selectedTime)
                        .frame(maxWidth: .infinity, alignment: .center) // 프레임과 정렬
                }
                // 요일 선택
                Section(header: Text("알림 요일 선택")) {
                    HStack {
                        ForEach(0..<weekdays.count, id: \.self) { index in
                            DayButton(day: weekdays[index], isSelected: $selectedWeekdays[index])
                        }
                    }
                    .contentShape(Rectangle()) // HStack의 터치 가능 영역을 제한
                }

                // 소지품 추가
                Section {
                    Button(action: {
                        // 소지품 추가 기능
                    }
                    ) {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(Color(red: 127 / 255, green: 127 / 255, blue: 127 / 255))
                            Text("여기를 눌러 소지품 추가")
                                .foregroundColor(Color(red: 127 / 255, green: 127 / 255, blue: 127 / 255))
                        }
                    }
                }
            }
            .navigationTitle("알림 추가")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DayButton: View {
    var day: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            withAnimation {
                isSelected.toggle()
                print("\(day) is now \(isSelected ? "selected" : "unselected")")
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

// 프리뷰
struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView()
    }
}
