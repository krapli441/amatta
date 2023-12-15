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

    var body: some View {
        VStack {
            ItemHeaderView()
            VStack(spacing: 15) {
                SectionHeaderView(title: "소지품 이름")
                TextField("이름을 입력해주세요", text: $itemName)
//                    .textFieldStyle() // 스타일을 적용할 수 있습니다.

                SectionHeaderView(title: "무언가 담을 수 있나요?")
                Toggle("네", isOn: $isContainer)
//                    .toggleStyle() // 토글 스타일을 적용할 수 있습니다.

                if isContainer {
                    SectionHeaderView(title: "그 안에 무엇이 들어가나요?")
                    // 물품 추가 로직
                }

                SectionHeaderView(title: "중요한 물건인가요?")
                Slider(value: $importance, in: 1...10, step: 1)
//                    .sliderStyle() // 슬라이더 스타일을 적용할 수 있습니다.

                Button("추가") {
                    // 새 Items 객체 생성 및 CoreData에 저장 로직
                }
//                .buttonStyle() // 버튼 스타일을 적용할 수 있습니다.
            }
            .padding()
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
