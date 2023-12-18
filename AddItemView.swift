//
//  AddAlarmView.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//

import Foundation
import SwiftUI

// 임시 데이터를 저장할 클래스
class AlarmCreationData: ObservableObject {
    @Published var items: [TemporaryItem] = []
}

// 임시 아이템 데이터 구조
struct TemporaryItem: Identifiable {
    let id = UUID()
    var name: String
    var isContainer: Bool
    var importance: Float
    var containedItems: [String] = []
}

struct AddItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @StateObject var alarmCreationData: AlarmCreationData

    @State private var itemName: String = ""
    @State private var canContainOtherItems: Bool = false
    @State private var importance: Float = 1
    @State private var containedItems: [String] = []
    var editingItem: TemporaryItem?

    init(alarmCreationData: AlarmCreationData, editingItem: TemporaryItem?) {
        _alarmCreationData = StateObject(wrappedValue: alarmCreationData)
        self.editingItem = editingItem
        if let editingItem = editingItem {
            _itemName = State(initialValue: editingItem.name)
            _canContainOtherItems = State(initialValue: editingItem.isContainer)
            _importance = State(initialValue: editingItem.importance)
            _containedItems = State(initialValue: editingItem.containedItems)
        }
    }

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
                    
                    if canContainOtherItems {
                    SectionHeaderView(title: "그 안에 무엇이 들어가나요?")
                    ForEach(containedItems.indices, id: \.self) { index in
                        HStack {
                               TextField("이름", text: $containedItems[index])
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
                    // 여기에 나머지 뷰 구성 요소 추가
                }
            }
            addButton()
            // 추가적인 버튼이나 기능을 여기에 추가
        }
        .onTapGesture { hideKeyboard() }
        .animation(.easeInOut, value: canContainOtherItems)
        .onAppear {
            print("Editing Item: \(String(describing: editingItem))")
        }
    }
    
    private func removeItem(at index: Int) {
        withAnimation(.easeInOut) {
            containedItems.remove(at: index)
        }
    }
    

    private func addItemButton() -> some View {
        Button(action: {
            withAnimation {
                containedItems.append("")
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
    
    private func addButton() -> some View {
        Button(action: {
            // containedItems를 포함하여 TemporaryItem 생성
            let newItem = TemporaryItem(name: itemName, isContainer: canContainOtherItems, importance: importance, containedItems: containedItems)
            alarmCreationData.items.append(newItem)
            print("물건 추가됨: \(newItem)")
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("추가")
            .foregroundColor(.white)
            .frame(maxWidth: 320)
            .padding()
            .background(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
            .cornerRadius(10)
        }
    }


    

    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        AddItemView(alarmCreationData: AlarmCreationData(), editingItem: nil)
    }
}

