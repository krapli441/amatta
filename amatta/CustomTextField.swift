//
//  CustomTextField.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: "테스트", text: .constant("텍스트 입력"))
    }
}
