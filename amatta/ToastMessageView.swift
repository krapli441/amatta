//
//  ToastMessageView.swift
//  amatta
//
//  Created by 박준형 on 12/20/23.
//

import Foundation
import SwiftUI

struct ToastView: View {
    @Binding var isShowing: Bool
    let text: String

    var body: some View {
        if isShowing {
            Text(text)
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isShowing = false
                    }
                }
        }
    }
}

// 뷰에 토스트 메시지 추가
extension View {
    func toast(isShowing: Binding<Bool>, text: String) -> some View {
        ZStack {
            self
            ToastView(isShowing: isShowing, text: text)
        }
    }
}
