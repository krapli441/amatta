//
//  SettingHeaderView.swift
//  amatta
//
//  Created by 박준형 on 1/3/24.
//

import Foundation
import SwiftUI

struct SettingHeaderView: View {
    var body: some View {
        HStack {
            Text("환경설정")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                .padding(.leading, 45)
            Spacer()
        }
        .padding(.top, 20)
    }
}

struct SettingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingHeaderView()
    }
}
