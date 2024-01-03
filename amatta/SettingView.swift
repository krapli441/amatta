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
    @State private var isNotificationsEnabled = false
    @State private var showingAlert = false
    @State private var userToggledSwitch = false

    var body: some View {
        VStack {
            SettingHeaderView()

            // '알림' 설정 박스
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
                        userToggledSwitch = true  // 사용자가 토글 스위치를 조작함을 나타냄
                        if userToggledSwitch {
                            showingAlert = true
                        }
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
        }
    }

    private func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationsEnabled = (settings.authorizationStatus == .authorized)
                userToggledSwitch = false  // onAppear에서 사용자가 조작하지 않았으므로 false로 설정
            }
        }
    }

    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}



