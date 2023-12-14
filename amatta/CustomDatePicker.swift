//
//  CustomDatePicker.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import SwiftUI

struct CustomDatePicker: UIViewRepresentable {
    @Binding var selection: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = self.selection
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(selection: .constant(Date()))
    }
}
