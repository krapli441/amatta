//
//  SettingView.swift
//  amatta
//
//  Created by 박준형 on 1/3/24.
//

import Foundation
import SwiftUI
import UserNotifications

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isNotificationsEnabled = true
    @State private var previousToggleState = false
    @State private var showingAlert = false

    var body: some View {
        VStack {
            SettingHeaderView()

            VStack {
                HStack {
                    Text("알림")
                        .font(.system(size: 18))
                        .foregroundColor(Color.primary)

                    Spacer()

                    Toggle(isOn: $isNotificationsEnabled) {
                        Text("")
                    }
                    .onChange(of: isNotificationsEnabled) { newValue in
                        if newValue != previousToggleState {
                            // 토글 상태가 변경된 경우에만 경고창 표시
                            showingAlert = true
                        }
                        previousToggleState = newValue
                    }
                }
                .padding()
            }
            .frame(maxWidth: 360)
            .background(colorScheme == .dark ? Color(white: 0.2) : Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("알림 변경"),
                    message: Text("앱 설정에서 알림을 켜거나 끌 수 있습니다."),
                    primaryButton: .default(Text("설정으로 이동"), action: openAppSettings),
                    secondaryButton: .cancel(Text("취소"))
                )
            }

            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            checkNotificationAuthorizationStatus()
            previousToggleState = isNotificationsEnabled
        }
    }

    private func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationsEnabled = (settings.authorizationStatus == .authorized)
            }
        }
    }

    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}




