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
                    .onChange(of: isNotificationsEnabled) { _ in
                        // 스위치 상태가 변경될 때마다 경고창 표시
                        showingAlert = true
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
                // 권한 상태에 따라 스위치 상태 설정
                self.isNotificationsEnabled = (settings.authorizationStatus == .authorized)
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



