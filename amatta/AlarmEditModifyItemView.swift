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
    
    // selectedItemObjectID 추가
    var itemObjectID: NSManagedObjectID?
    
    // 이니셜라이저를 추가하여 selectedItemObjectID를 설정
    init(itemObjectID: NSManagedObjectID?) {
        self.itemObjectID = itemObjectID
    }
    
    var body: some View {
        VStack {
            EditItemHeaderView() // 물건 변경
            ScrollView {
                Text("Selected Item ObjectID: \(itemObjectID?.description ?? "None")") // 콘솔에 출력할 부분
            }
        }
    }
}

struct AlarmEditModifyItemView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmEditModifyItemView(itemObjectID: nil)
    }
}
