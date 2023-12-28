//
//  AddItemView.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//

import Foundation
import SwiftUI


struct EditItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @StateObject var alarmCreationData: AlarmCreationData
    @State private var showingDeleteAlert = false
    @State private var itemName: String = ""
    @State private var canContainOtherItems: Bool = false
    @State private var importance: Float = 1
    @State private var containedItems: [ContainedItem]
    var editingItem: TemporaryItem?

    init(alarmCreationData: AlarmCreationData, editingItem: TemporaryItem?) {
        _alarmCreationData = StateObject(wrappedValue: alarmCreationData)
        self.editingItem = editingItem
        if let editingItem = editingItem {
            _itemName = State(initialValue: editingItem.name)
            _canContainOtherItems = State(initialValue: editingItem.isContainer)
            _importance = State(initialValue: editingItem.importance)
            _containedItems = State(initialValue: editingItem.containedItems.enumerated().map { index, name in ContainedItem(name: name, orderIndex: index) })
        }
    }

    var isUpdateButtonDisabled: Bool {
            itemName.isEmpty || containedItems.contains { $0.name.isEmpty }
        }

       var updateButtonBackgroundColor: Color {
           isUpdateButtonDisabled ? Color.gray : Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255)
       }
    
    var body: some View {
        VStack {
            EditItemHeaderView() // 물건 추가 헤더

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
                    // 여기에 나머지 뷰 구성 요소 추가
                }
            }
            HStack {
                        deleteButton()
                        updateButton()
                    }
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
    
    private func updateButton() -> some View {
        Button(action: {
                    if let editingItemID = editingItem?.id {
                        if let index = alarmCreationData.items.firstIndex(where: { $0.id == editingItemID }) {
                            // containedItems를 String 배열로 변환
                            let updatedContainedItems = containedItems.map { $0.name }
                            let updatedItem = TemporaryItem(
                                id: editingItemID,
                                name: itemName,
                                isContainer: canContainOtherItems,
                                importance: importance,
                                containedItems: updatedContainedItems, // String 배열로 변환
                                creationDate: Date()
                            )
                            alarmCreationData.items[index] = updatedItem
                            print("물건 변경됨: \(updatedItem)")
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
        }) {
            Text("변경")
                .foregroundColor(.white)
                 .frame(width: 140)
                 .padding()
                 .background(updateButtonBackgroundColor)
                 .cornerRadius(10)
        }
        .disabled(isUpdateButtonDisabled)
                .animation(.easeInOut, value: isUpdateButtonDisabled)
    }

    private func addItemButton() -> some View {
        Button(action: {
            withAnimation {
                let newIndex = containedItems.count
                containedItems.append(ContainedItem(name: "", orderIndex: newIndex))
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
    
    
    private func deleteButton() -> some View {
        Button(action: {
            showingDeleteAlert = true
        }) {
            Text("삭제")
                .foregroundColor(.white)
                .frame(width: 140)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
        }
        .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("물건을 삭제하시겠어요?"),
                        primaryButton: .destructive(Text("삭제")) {
                            deleteItem()
                        },
                        secondaryButton: .cancel()
                    )
                }
    }
    
    private func deleteItem() {
            if let editingItemID = editingItem?.id {
                if let index = alarmCreationData.items.firstIndex(where: { $0.id == editingItemID }) {
                    alarmCreationData.items.remove(at: index)
                    print("물건 삭제됨")
                }
            }
            presentationMode.wrappedValue.dismiss()
        }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}


struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(alarmCreationData: AlarmCreationData(), editingItem: nil)
    }
}

