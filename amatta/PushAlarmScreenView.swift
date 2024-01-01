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
            if tappedAlarm {
                // tappedAlarm이 true일 때만 알림 정보 표시
                if let alarmData = alarmData {
                    Text("알람 이름: \(alarmData.alarmName)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    // 알림 정보를 표시하는 나머지 부분 추가
                } else {
                    Text("알람 정보를 불러올 수 없습니다.")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
            } else {
                // tappedAlarm이 false일 때의 뷰 (또는 다른 처리)
                Text("알람 정보를 불러올 수 없습니다.")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .navigationBarTitle("알람 상세 정보", displayMode: .inline)
        .onDisappear {
            // PushAlarmScreenView에서 나갈 때 tappedAlarm을 false로 설정합니다.
            tappedAlarm = false
        }
    }
}



//struct PushAlarmScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        PushAlarmScreenView(alarmData: AlarmData())
//    }
//}
