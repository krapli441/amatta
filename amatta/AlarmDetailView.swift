//
//  ItemCheckView.swift
//  amatta
//
//  Created by 박준형 on 12/29/23.
//

import Foundation
import SwiftUI
import CoreData

struct AlarmDetailView: View {
    var alarm: Alarm
    
    var body: some View {
        // Alarm 객체의 상세 정보를 표시합니다.
        Text("알림 이름: \(alarm.name ?? "알 수 없음")")
        // 여기에 더 많은 알림 상세 정보 표시 로직을 추가할 수 있습니다.
    }
}
