//
//  AddAlarmView.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//

import Foundation
import SwiftUI

struct AddItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var itemName: String = "" // 사용자가 입력할 아이템 이름을 저장하기 위한 State 변수

    var body: some View {
        VStack {
            ItemHeaderView() // 물건 추가 헤더

            ScrollView {
                VStack(spacing: 12) {
                    // 물건 이름 섹션
                    SectionHeaderView(title: "물건 이름")
                    CustomTextField(placeholder: "이름을 입력해주세요", text: $itemName)
                        .frame(maxWidth: 320)
                        .commonInputStyle(colorScheme: colorScheme)

                    // 여기에 나머지 뷰 구성 요소 추가
                }
            }
            // 추가적인 버튼이나 기능을 여기에 추가
        }
        // 여기에 필요한 스타일 또는 레이아웃 조정
    }
}


struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}






