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
            if let alarmData = alarmData {
                Text("알람 이름: \(alarmData.alarmName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                List(alarmData.items, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(item.name)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                        
                        Text("중요도: \(item.importance)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // 하위 아이템 표시 (필요한 경우)
                        if !item.children.isEmpty {
                            ForEach(item.children, id: \.self) { childItem in
                                Text("\(childItem.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 8)
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
    }
}


//struct PushAlarmScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        PushAlarmScreenView(alarmData: AlarmData())
//    }
//}
