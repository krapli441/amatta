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
    @State private var userInteracted = false // 사용자의 상호작용을 감지하는 상태 변수

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
                    .onTapGesture {
                        self.userInteracted = true // 사용자가 토글을 탭할 때 상호작용 상태를 true로 설정
                    }
                    .onChange(of: isNotificationsEnabled) { _ in
                        if userInteracted {
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
                    secondaryButton: .cancel()
                )
            }

            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            userInteracted = false // onAppear에서 초기화
            checkNotificationAuthorizationStatus()
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
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl)
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}



