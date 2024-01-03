//
//  SettingView.swift
//  amatta
//
//  Created by 박준형 on 1/3/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct SettingView: View {
    @State private var isNotificationsEnabled = false // 토글 스위치 상태를 위한 상태 변수

    var body: some View {
        VStack {
            SettingHeaderView()

            // 회색 테두리 선이 있는 '알림' 설정 박스
            VStack {
                HStack {
                    Text("알림")
                        .font(.system(size: 18))
                        .foregroundColor(Color.primary)
                    Spacer() // 텍스트와 스위치 사이의 공간
                    Toggle(isOn: $isNotificationsEnabled) {
                        Text("") // Toggle에 대한 라벨 없음
                    }
                }
                .padding()
            }
            .frame(maxWidth: 360)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()

            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
                    checkNotificationAuthorizationStatus()
                }
    }
    
    
    private func checkNotificationAuthorizationStatus() {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    // 권한 상태에 따라 스위치 상태 설정
                    self.isNotificationsEnabled = (settings.authorizationStatus == .authorized)
                }
            }
        }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}



