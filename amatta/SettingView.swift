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
    // 필요한 경우 상태 변수를 여기에 추가할 수 있습니다.

    var body: some View {
        VStack {
            SettingHeaderView()

            // 회색 테두리 선이 있는 '알림' 설정 박스
            VStack {
                Text("알림")
                    .font(.system(size: 18))
                    .padding()
                // 추후에 여기에 스위치나 다른 UI 요소를 추가할 수 있습니다.
            }
            .frame(maxWidth: 360, maxHeight: 15)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()

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


