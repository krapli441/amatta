//
//  AlarmHeaderView.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import SwiftUI

struct AlarmHeaderView: View {
    var body: some View {
        HStack {
            Text("알림 추가")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                .padding(.leading, 20)
            Spacer()
        }
        .padding(.top, 20)
    }
}

struct AlarmHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHeaderView()
    }
}
