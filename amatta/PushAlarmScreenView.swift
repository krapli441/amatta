//
//  PushAlarmScreenView.swift
//  amatta
//
//  Created by 박준형 on 1/1/24.
//

import Foundation
import SwiftUI

struct PushAlarmScreenView: View {
    @Binding var alarmData: AlarmData?
    @Binding var tappedAlarm: Bool

    var body: some View {
        VStack {
            if tappedAlarm, let alarmData = alarmData {
                // PushAlarmHeaderView를 사용하여 알람 이름 표시
                PushAlarmHeaderView(alarmName: alarmData.alarmName)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(alarmData.items, id: \.self) { item in
                            itemRow(item)
                        }
                    }
                    .padding(.top, 10)
                }
            } else {
                Text("알람 정보를 불러올 수 없습니다.")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .navigationBarTitle("알람 상세 정보", displayMode: .inline)
        .onDisappear {
            tappedAlarm = false
        }
    }

    // 물건 정보와 하위 물건들을 표시하는 함수
    private func itemRow(_ item: AlarmData.Item) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.name)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            ForEach(item.children, id: \.self) { childItem in
                Text(childItem.name)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: 360)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}


