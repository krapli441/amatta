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
            .frame(maxWidth: 350) // 최대 너비 설정
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
