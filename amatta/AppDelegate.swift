//
//  AppDelegate.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import UIKit
import UserNotifications
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // CoreData context 설정
    var persistentContainer: NSPersistentContainer!
    var alarmData = AlarmData()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 알림 센터 대리자 설정
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // 알림을 탭했을 때 호출되는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let alarmIdentifier = userInfo["alarmIdentifier"] as? String {
            // CoreData에서 알림 정보 조회
            fetchAlarm(with: alarmIdentifier)
            // 상태 변경 - 사용자가 알림을 탭한 경우
            NotificationCenter.default.post(name: Notification.Name("PushAlarmTapped"), object: nil, userInfo: ["alarmIdentifier": alarmIdentifier])
        }

        completionHandler()
    }

    // CoreData에서 알림 정보를 조회하는 메소드
    internal func fetchAlarm(with identifier: String) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Alarm>(entityName: "Alarm")
        fetchRequest.predicate = NSPredicate(format: "alarmIdentifier == %@", identifier)

        do {
            let alarms = try context.fetch(fetchRequest)
            if let alarm = alarms.first {
                // alarmData와 items를 안전하게 초기화
                var newAlarmData = AlarmData()
                newAlarmData.alarmName = alarm.name ?? "Unknown"
                newAlarmData.items = convertItemsToAlarmDataItems(items: alarm.items as? Set<Items> ?? [])

                // AlarmData 객체에 저장된 정보 출력
                print("Stored Alarm Data:")
                print("Alarm Name: \(newAlarmData.alarmName)")
                printItems(newAlarmData.items, indentLevel: 0)

                // 최종적으로 alarmData에 할당
                alarmData = newAlarmData
            }
        } catch {
            print("Error fetching alarm: \(error)")
        }
    }


    internal func printItems(_ items: [AlarmData.Item], indentLevel: Int) {
        let indent = String(repeating: "    ", count: indentLevel)
        for item in items {
            print("\(indent)\(item.name) (중요도: \(item.importance))")
            if !item.children.isEmpty {
                printItems(item.children, indentLevel: indentLevel + 1)
            }
        }
    }

    
    internal func convertItemsToAlarmDataItems(items: Set<Items>) -> [AlarmData.Item] {
            return items.map { item in
                AlarmData.Item(
                    name: item.name ?? "Unknown",
                    importance: item.importance,
                    children: convertItemsToAlarmDataItems(items: item.children as? Set<Items> ?? [])
                )
            }
        }
}



