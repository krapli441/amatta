//
//  CustomDatePicker.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import SwiftUI

struct CustomDatePicker: View {
    @Binding var selection: Date
    @State private var isPickerPresented = false
    @Environment(\.colorScheme) var colorScheme

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selection)
    }

    var body: some View {
        Button(action: {
            self.isPickerPresented = true
        }) {
            HStack {
                Spacer()
                Text(formattedTime)
                    .foregroundColor(.primary)
                Spacer()
            }
//            .padding()
            .frame(maxWidth: 350) // 최대 너비 설정
//            .background(colorScheme == .dark ? Color(white: 0.2) : Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255))
//            .cornerRadius(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
        }
        .sheet(isPresented: $isPickerPresented) {
            VStack {
                DatePicker("", selection: $selection, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                Button("완료") {
                    self.isPickerPresented = false
                }
                .padding()
            }
            .presentationDetents([.fraction(0.35)])
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(selection: .constant(Date()))
    }
}
