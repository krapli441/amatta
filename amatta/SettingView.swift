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

            // 회색 테두리 선이 있는 '알림' 설정 박스
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
                        if newValue {
                            checkNotificationAuthorizationStatus() { enabled in
                                if !enabled {
                                    // 스위치가 on으로 바뀌었지만, 알림 권한이 없는 경우
                                    self.showingAlert = true
                                    self.isNotificationsEnabled = false
                                }
                            }
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
                    title: Text("알림 설정 변경"),
                    message: Text("알림을 다시 켜려면, 설정 앱에서 이 앱의 알림을 허용해야 합니다."),
                    dismissButton: .default(Text("설정으로 이동"), action: openAppSettings)
                )
            }

            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            checkNotificationAuthorizationStatus() { enabled in
                self.isNotificationsEnabled = enabled
            }
        }
    }

    private func checkNotificationAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
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



