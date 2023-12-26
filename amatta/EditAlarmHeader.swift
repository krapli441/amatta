//
//  EditItemHeaderView.swift
//  amatta
//
//  Created by 박준형 on 12/21/23.
//

import Foundation
import SwiftUI

struct EditAlarmHeaderView: View {
    var body: some View {
        HStack {
            Text("알림 수정")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                .padding(.leading, 45)
            Spacer()
        }
        .padding(.top, 20)
    }
}

struct EditAlarmHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHeaderView()
    }
}
