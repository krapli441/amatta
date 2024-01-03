//
//  SettingView.swift
//  amatta
//
//  Created by 박준형 on 1/3/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            // 헤더를 VStack의 상단에 배치
            SettingHeaderView()
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

