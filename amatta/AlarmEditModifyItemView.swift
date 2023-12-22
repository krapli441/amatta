//
//  AddItemView.swift
//  amatta
//
//  Created by 박준형 on 12/15/23.
//

import Foundation
import SwiftUI
import CoreData


struct AlarmEditModifyItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @StateObject var alarmCreationData: AlarmCreationData
    @State private var showingDeleteAlert = false
    @State private var itemName: String = ""
    @State private var canContainOtherItems: Bool = false
    @State private var importance: Float = 1
    @State private var containedItems: [String] = []
    var editingItem: Items?
    var onItemUpdated: () -> Void

    init(alarmCreationData: AlarmCreationData, editingItem: Items?, onItemUpdated: @escaping () -> Void) {
            _alarmCreationData = StateObject(wrappedValue: alarmCreationData)
            self.editingItem = editingItem
            self.onItemUpdated = onItemUpdated

            if let editingItem = editingItem {
                _itemName = State(initialValue: editingItem.name ?? "")
                _canContainOtherItems = State(initialValue: editingItem.isContainer)
                _importance = State(initialValue: editingItem.importance)
                _containedItems = State(initialValue: editingItem.childrenArray.map { $0.name ?? "" })
            }
        }

    var isUpdateButtonDisabled: Bool {
           itemName.isEmpty || containedItems.contains { $0.isEmpty }
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
            // 선택된 아이템과 관련된 Managed Object Context를 가져옵니다.
            if let itemToEdit = editingItem, let context = itemToEdit.managedObjectContext {
                // CoreData의 아이템에 대한 세부 정보를 업데이트합니다.
                itemToEdit.name = self.itemName
                itemToEdit.isContainer = self.canContainOtherItems
                itemToEdit.importance = self.importance
                
                // 자식 아이템 업데이트 로직을 호출합니다.
                updateChildItems(for: itemToEdit, with: containedItems, in: context)

                // 변경 사항을 저장합니다.
                do {
                    try context.save()
                    print("물건 변경됨: \(itemToEdit)")
                } catch {
                    print("물건 변경 실패: \(error)")
                }
            }
            // 현재 뷰를 닫습니다.
            presentationMode.wrappedValue.dismiss()
        }) {
            // 버튼 UI 설정
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

    private func updateChildItems(for item: Items, with names: [String], in context: NSManagedObjectContext) {
        // 기존 자식 아이템들 삭제
        if let existingChildren = item.children as? Set<Items> {
            existingChildren.forEach { context.delete($0) }
        }

        // 새로운 자식 아이템들 추가
        names.forEach { name in
            let newChild = Items(context: context)
            newChild.name = name
            newChild.isContainer = false // 자식 아이템은 컨테이너가 아님
            item.addToChildren(newChild)
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
//                            deleteItem()
                        },
                        secondaryButton: .cancel()
                    )
                }
    }
    
//    private func deleteItem() {
//            if let editingItemID = editingItem?.id {
//                if let index = alarmCreationData.items.firstIndex(where: { $0.id == editingItemID }) {
//                    alarmCreationData.items.remove(at: index)
//                    print("물건 삭제됨")
//                }
//            }
//            presentationMode.wrappedValue.dismiss()
//        }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}


struct AlarmEditModifyItemView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmEditModifyItemView(
            alarmCreationData: AlarmCreationData(),
            editingItem: nil,
            onItemUpdated: {} // 빈 클로저 제공
        )
    }
}


