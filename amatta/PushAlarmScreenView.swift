//
//  PushAlarmScreenView.swift
//  amatta
//
//  Created by 박준형 on 1/1/24.
//

import Foundation
import SwiftUI

struct PushAlarmScreenView: View {
    let alarmName: String

    var body: some View {
        PushAlarmHeaderView(alarmName: alarmName)
    }
}
    
struct PushAlarmScreenView_Previews: PreviewProvider {
    static var previews: some View {
        PushAlarmScreenView(alarmName: "미리보기 알림")
    }
}
