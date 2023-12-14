//
//  DayButton.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import SwiftUI

struct DayButton: View {
    var day: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            withAnimation {
                isSelected.toggle()
            }
        }) {
            Text(day)
                .foregroundColor(isSelected ? .white : .blue)
                .padding()
                .font(.system(size: 14))
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 1)
                )
        }
    }
}

struct DayButton_Previews: PreviewProvider {
    static var previews: some View {
        DayButton(day: "월", isSelected: .constant(true))
    }
}
