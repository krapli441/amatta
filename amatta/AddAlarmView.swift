//
//  AddAlarmView.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import Foundation
import SwiftUI

struct AddAlarmView: View {
    var body: some View {
        VStack {
            Text("알림 추가")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
    }
}

// 프리뷰
struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView()
    }
}
