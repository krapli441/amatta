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
                    .multilineTextAlignment(.center) // 텍스트를 가운데로 정렬
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255))
                    .cornerRadius(10)
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
