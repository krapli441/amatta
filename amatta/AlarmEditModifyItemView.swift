//
//  AddItemView.swift
//  amatta
//
//  Created by 박준형 on 12/25/23.
//

import Foundation
import SwiftUI
import CoreData

struct AlarmEditModifyItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Binding var itemObjectID: NSManagedObjectID?

    @State private var itemDetails: String = "Loading..."
    
    @State private var showingDeleteAlert = false
    
    @State private var itemName: String = ""
    @State private var canContainOtherItems: Bool = false
    @State private var importance: Float = 1
    @State private var containedItems: [String] = []

    init(itemObjectID: Binding<NSManagedObjectID?>) {
        self._itemObjectID = itemObjectID
    }

    var body: some View {
        VStack {
            EditItemHeaderView() // 물건 변경 헤더
            ScrollView {
                VStack(spacing: 12) {
                    SectionHeaderView(title: "물건 이름")
                    CustomTextField(placeholder: "이름을 입력해주세요", text: $itemName)
                        .frame(maxWidth: 320)
                        .commonInputStyle(colorScheme: colorScheme)

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
                                                .frame(width: 325)

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
                }
            }
            .onAppear {
                loadItemDetails()
            }
            .animation(.easeInOut, value: canContainOtherItems)
        }
        HStack {
                        deleteButton()
                        updateButton()
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
        guard let objectID = itemObjectID else { return }

        let itemToDelete = managedObjectContext.object(with: objectID)
        managedObjectContext.delete(itemToDelete)

        do {
            try managedObjectContext.save()
            print("물건 삭제됨")
        } catch {
            print("삭제 실패: \(error)")
        }

        presentationMode.wrappedValue.dismiss()
    }

    private func updateButton() -> some View {
        Button(action: {
            // 여기에 업데이트 기능을 넣을 예정
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
    
    // 변경 버튼이 비활성화되어야 하는 조건
    var isUpdateButtonDisabled: Bool {
        itemName.isEmpty || containedItems.contains { $0.isEmpty }
    }

    // 변경 버튼의 배경 색상
    var updateButtonBackgroundColor: Color {
        isUpdateButtonDisabled ? Color.gray : Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255)
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

    private func removeItem(at index: Int) {
        withAnimation(.easeInOut) {
            containedItems.remove(at: index)
        }
    }

    private func loadItemDetails() {
            guard let objectID = itemObjectID, let item = managedObjectContext.object(with: objectID) as? Items else {
                return
            }

            itemName = item.name ?? "Unknown"
            canContainOtherItems = item.isContainer
            importance = item.importance

            if let children = item.children as? Set<Items>, !children.isEmpty {
                containedItems = children.map { $0.name ?? "Unknown" }
            }
        }
}

struct AlarmEditModifyItemView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmEditModifyItemView(itemObjectID: .constant(nil))
    }
}


