//
//  AlarmEditAddItemView.swift
//  amatta
//
//  Created by 박준형 on 12/22/23.
//

import Foundation
import SwiftUI
import CoreData

struct AlarmEditAddItemView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
        @Environment(\.presentationMode) var presentationMode
        @Environment(\.colorScheme) var colorScheme
    
    var alarmID: NSManagedObjectID
    
    @State private var itemName: String = ""
    @State private var canContainOtherItems: Bool = false
    @State private var importance: Float = 1
    @State private var containedItems: [ContainedItem] = []
    
    var body: some View {
        ItemHeaderView()
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
                
                if canContainOtherItems {
                SectionHeaderView(title: "그 안에 무엇이 들어가나요?")
                ForEach(containedItems.indices, id: \.self) { index in
                    HStack {
                        TextField("이름", text: $containedItems[index].name)
                               .padding(10)
                               .overlay(
                                   RoundedRectangle(cornerRadius: 10)
                                       .stroke(Color.gray, lineWidth: 1)
                               )
                               .frame(width: 325) // 여백을 고려하여 너비를 조정

                        Button(action: {
                            removeItem(at: index)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                       }
                    .transition(.opacity)
                    }
                addItemButton()
                .transition(.opacity)
                                    }
                SectionHeaderView(title: "얼마나 중요한 물건인가요?")
                Slider(value: $importance, in: 1...10, step: 1)
                .frame(maxWidth: 320)
                .commonInputStyle(colorScheme: colorScheme)
                .accentColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                Text("중요도가 높은 물건은 알림에 자주 나타납니다.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: 320, alignment: .leading)
            }
        }
    }
    
    private func addItemButton() -> some View {
        Button(action: {
            withAnimation {
                containedItems.append(ContainedItem(name: "", creationDate: Date()))
            }
        }) {
                HStack {
                    Image(systemName: "plus") // 아이콘 추가
                        .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255)) // 아이콘 색상 설정
                    Text("물건 추가")
                        .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                }
                .frame(maxWidth: 320)
                .commonInputStyle(colorScheme: colorScheme)
            }
        }
    
    private func removeItem(at index: Int) {
        withAnimation(.easeInOut) {
            containedItems.remove(at: index)
        }
    }
    
}
