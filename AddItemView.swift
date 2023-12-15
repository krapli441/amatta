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
    @State private var itemName: String = ""
    @State private var canContainOtherItems: Bool = false

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

                    // 무언가 담을 수 있나요? 섹션
                    SectionHeaderView(title: "무언가 담을 수 있나요?")
                    HStack {
                        Button("네") {
                            canContainOtherItems = true
                        }
                        .buttonStyle(ChoiceButtonStyle(isSelected: canContainOtherItems == true))

                        Button("아니요") {
                            canContainOtherItems = false
                        }
                        .buttonStyle(ChoiceButtonStyle(isSelected: canContainOtherItems == false))
                    }
                    .frame(maxWidth: 320)
                    
                    // 여기에 나머지 뷰 구성 요소 추가
                }
            }
            // 추가적인 버튼이나 기능을 여기에 추가
        }
        // 스타일 또는 레이아웃 조정
    }
}

// 선택 버튼 스타일
struct ChoiceButtonStyle: ButtonStyle {
    var isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 140, height: 15) // 버튼 크기 조정
            .foregroundColor(.white)
            .padding()
            .background(isSelected ? Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255) : Color.gray)
            .cornerRadius(8)
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}







