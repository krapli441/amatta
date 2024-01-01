//
//  PushAlarmHeaderView.swift
//  amatta
//
//  Created by 박준형 on 1/1/24.
//

import Foundation
import SwiftUI

struct PushAlarmHeaderView: View {
    let alarmName: String

    var body: some View {
        HStack {
            Text(alarmName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                .padding(.leading, 45)
            Spacer()
        }
        .padding(.top, 20)
    }
}


struct PushAlarmHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PushAlarmHeaderView(alarmName: "미리보기 알림")
    }
}
