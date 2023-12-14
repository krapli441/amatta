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

    var textColor: Color {
        switch day {
        case "토":
            return .blue
        case "일":
            return .red
        default:
            return .black
        }
    }

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0)) {
                isSelected.toggle()
            }
        }) {
            Text(day)
                .foregroundColor(textColor)
                .padding()
                .font(.system(size: 14))
                .overlay(
                    isSelected ? Circle().stroke(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255), lineWidth: 2)
                                .frame(width: 30, height: 30) : nil
                )
        }
    }
}

struct DayButton_Previews: PreviewProvider {
    static var previews: some View {
        DayButton(day: "월", isSelected: .constant(true))
    }
}


