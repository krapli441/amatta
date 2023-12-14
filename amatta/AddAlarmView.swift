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
                Text("알림 추가")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                    .padding(.top, 20)
                    .padding([.leading, .trailing], 40)

                Form {
                    Section(header: Text("알림 이름").font(.headline)) {
                        TextField("알림 이름을 입력해주세요.", text: $alarmName)
                    }

                    Section(header: Text("알림 시간").font(.headline)) {
                        CustomDatePicker(selection: $selectedTime)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Section(header: Text("요일 선택").font(.headline)) {
                        HStack {
                            ForEach(0..<weekdays.count, id: \.self) { index in
                                DayButton(day: weekdays[index], isSelected: $selectedWeekdays[index])
                            }
                        }
                    }

                    Section {
                        Button(action: {
                            // 소지품 추가 기능
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("여기를 눌러 소지품 추가")
                            }
                        }
                    }
                }
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
