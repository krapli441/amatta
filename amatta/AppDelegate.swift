////
////  AppDelegate.swift
////  amatta
////
////  Created by 박준형 on 12/14/23.
////
//
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 알림 센터 델리게이트 설정
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // 사용자가 알림을 터치하여 앱을 열었을 때 호출되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            if let alarmIDString = userInfo["alarmID"] as? String, let url = URL(string: alarmIDString), let alarmID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) {
                // 여기에서 AlarmDetailView로 이동하는 로직 구현
                // 예: 알람 ID를 기반으로 AlarmDetailView를 표시
            }
            completionHandler()
        }
}
