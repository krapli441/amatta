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
                    .frame(maxWidth: .infinity) // 상위 레이아웃의 너비를 최대한으로 설정
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

    private func itemRow(_ item: AlarmData.Item) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(item.children, id: \.self) { childItem in
                HStack {
                    Text("·")
                        .font(.subheadline)

                    Text(childItem.name)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
        .frame(maxWidth: .infinity) // 각 물건 박스를 상위 레이아웃의 중앙에 위치시킴
    }
}
