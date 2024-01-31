//
//  EditItemHeaderView.swift
//  amatta
//
//  Created by 박준형 on 12/21/23.
//

import Foundation
import SwiftUI

struct EditAlarmHeaderView: View {
    var onDelete: () -> Void  // 삭제 로직을 실행할 클로저
    @Binding var showingDeleteAlert: Bool

    var body: some View {
        HStack {
            Text("알림 변경")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                .padding(.leading, UIScreen.main.bounds.width * 0.1)

            Spacer()

            Button(action: {
                self.showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(Color.red)
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // 여기에서 패딩 값을 조정합니다.
            .contentShape(Rectangle()) // 이 부분이 터치 영역을 조절합니다.
        }
        .padding(.top, 20)
        .padding(.trailing, UIScreen.main.bounds.width * 0.1) // HStack에도 패딩을 적용합니다.

    }
}


struct EditAlarmHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHeaderView()
    }
}
