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
                // 알람 이름과 부제목을 항상 상단에 위치시킴
                PushAlarmHeaderView(alarmName: alarmData.alarmName)
                Text("놓고 간 물건은 없는지 확인해보세요!")
                    .font(.system(size: 20))
                    .frame(maxWidth: 360, alignment: .leading)
                    .padding(.top, 5)

                // 챙겨야 할 물건 정보만 ScrollView에 포함
                ScrollView {
                    VStack(spacing: 10) {
                        if alarmData.items.isEmpty {
                            // 챙겨야 할 물건이 없을 때의 메시지
                            Text("챙겨야 할 물건이 없습니다.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(alarmData.items, id: \.self) { item in
                                itemRow(item)
                            }
                            Text("잘 챙겼는지 헷갈린다면, 눈으로 확인하는 것도 좋아요!")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.top, 10)
                }
                .frame(maxWidth: .infinity)

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
            HStack {
                Text(item.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)

                Spacer() // 좌우 대칭을 위해 Spacer 추가

                // 중요도가 8 이상일 때 '중요' 표시
                if item.importance >= 8 {
                    Text("중요")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.red)
                }
            }
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
