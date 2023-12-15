//
//  AddAlarmView.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//

import Foundation
import SwiftUI


struct AddItemView: View {
    @State private var itemName: String = ""
    @State private var isContainer: Bool = false
    @State private var importance: Double = 1
    @State private var containerSelection: Bool? // '네' 또는 '아니오' 선택 상태 관리
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            ItemHeaderView()
            VStack(spacing: 25) {
                inputSection(title: "물건 이름", content: CustomTextField(placeholder: "이름을 입력해주세요.", text: $itemName))

                SectionHeaderView(title: "무언가 담을 수 있나요?")
                HStack {
                    Button("네") {
                        containerSelection = true
                    }
//                    .buttonStyle() // 스타일 적용

                    Button("아니오") {
                        containerSelection = false
                    }
//                    .buttonStyle() // 스타일 적용
                }
                .frame(maxWidth: 320) // 버튼 너비 조절

                if containerSelection == true {
                    SectionHeaderView(title: "그 안에 무엇이 들어가나요?")
                    // 물품 추가 로직
                }

                SectionHeaderView(title: "중요한 물건인가요?")
                Slider(value: $importance, in: 1...10, step: 1)
                    .frame(maxWidth: 320) // 슬라이더 너비 조절

                Button("추가") {
                    // 새 Items 객체 생성 및 CoreData에 저장 로직
                }
//                .buttonStyle() // 버튼 스타일 적용
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func inputSection<Content: View>(title: String, content: Content) -> some View {
        SectionHeaderView(title: title)
        content
            .frame(maxWidth: 300)
            .commonInputStyle(colorScheme: colorScheme)
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}

