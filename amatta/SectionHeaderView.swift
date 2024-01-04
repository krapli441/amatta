//
//  SectionHeaderView.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import SwiftUI

struct SectionHeaderView: View {
    let title: String
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.leading, sizeClass == .compact ? 15 : 45)
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(title: "섹션 제목")
        .environment(\.horizontalSizeClass, .compact)
    }
}
