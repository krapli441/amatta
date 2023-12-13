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
                Section(header: Text("요일 선택")) {
                    Toggle("월", isOn: $selectedWeekdays[0])
                    Toggle("화", isOn: $selectedWeekdays[1])
                    Toggle("수", isOn: $selectedWeekdays[2])
                    Toggle("목", isOn: $selectedWeekdays[3])
                    Toggle("금", isOn: $selectedWeekdays[4])
                    Toggle("토", isOn: $selectedWeekdays[5])
                    Toggle("일", isOn: $selectedWeekdays[6])
                }

                // 소지품 추가
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
            .navigationTitle("알림 추가")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// 프리뷰
struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView()
    }
}
