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

    init(itemObjectID: Binding<NSManagedObjectID?>) {
        self._itemObjectID = itemObjectID
    }

    var body: some View {
        VStack {
            EditItemHeaderView() // 물건 변경
            VStack(spacing: 12) {
                SectionHeaderView(title: "물건 이름")
                CustomTextField(placeholder: "이름을 입력해주세요", text: $itemName)
                    .frame(maxWidth: 320)
                    .commonInputStyle(colorScheme: colorScheme)
            }
            .onAppear {
                loadItemDetails()
            }
        }
    }

    private func loadItemDetails() {
        guard let objectID = itemObjectID, let item = managedObjectContext.object(with: objectID) as? Items else {
            itemDetails = "Item not found"
            return
        }

        // @State 변수 itemName에 아이템 이름 할당
        itemName = item.name ?? "Unknown"

        let itemImportance = item.importance
        let isContainer = item.isContainer ? "Yes" : "No"

        // 기본 아이템 정보
        itemDetails = "Importance: \(itemImportance)\nIs Container: \(isContainer)"

        // 컨테이너일 경우 하위 아이템 정보 추가
        if item.isContainer, let children = item.children as? Set<Items>, !children.isEmpty {
            let childItemsDetails = children
                .sorted { ($0.creationDate ?? Date.distantPast) < ($1.creationDate ?? Date.distantPast) }
                .map { child in
                    "Child Item: \(child.name ?? "Unknown"), Creation Date: \(child.creationDate ?? Date()), ObjectID: \(child.objectID)"
                }
                .joined(separator: "\n")
            
            itemDetails += "\n\n\(childItemsDetails)"
        }
    }



}

struct AlarmEditModifyItemView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmEditModifyItemView(itemObjectID: .constant(nil))
    }
}


