//
//  AddAlarmView.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//

import Foundation
import SwiftUI

struct AddItemView: View {
    // 여기에 필요한 State 변수들을 선언할 수 있습니다.
    // 예: @State private var itemName: String = ""

    var body: some View {
        VStack {
            // '물건 추가' 헤더
            Text("물건 추가")
                .font(.largeTitle) // 폰트 크기 조절
                .padding() // 패딩 추가

            // 여기에 나머지 뷰 구성 요소를 추가합니다.
            // 예: TextField, Toggle, Slider 등
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}





