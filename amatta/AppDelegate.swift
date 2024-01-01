//
//  AppDelegate.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 알림 센터 대리자 설정
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // 알림을 탭했을 때 호출되는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let alarmIdentifier = userInfo["alarmIdentifier"] as? String {
            // alarmIdentifier로 필요한 작업 수행
            // 예: 해당 알람의 정보를 조회하고 PushAlarmScreenView로 이동
        }

        completionHandler()
    }
}


