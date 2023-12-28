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
                        TextField("이름", text: $containedItems[index])
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .frame(width: 325)
                    }
                }

                SectionHeaderView(title: "얼마나 중요한 물건인가요?")
                Slider(value: $importance, in: 1...10, step: 1)
                    .frame(maxWidth: 320)
                    .commonInputStyle(colorScheme: colorScheme)
                    .accentColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
            }
            .onAppear {
                loadItemDetails()
            }
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


