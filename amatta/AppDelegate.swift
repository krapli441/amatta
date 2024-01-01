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
    var alarmManager = AlarmManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 알림 센터 대리자 설정
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 기존 로직...

        // CoreData에서 알림 정보를 조회하는 코드
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Alarm>(entityName: "Alarm")
        // 여기서는 예시로 알림의 userInfo에서 식별자를 가져오는 코드를 가정합니다.
        if let alarmIdentifier = response.notification.request.content.userInfo["alarmIdentifier"] as? String {
            fetchRequest.predicate = NSPredicate(format: "alarmIdentifier == %@", alarmIdentifier)

            do {
            let alarms = try context.fetch(fetchRequest)
            if let alarm = alarms.first {
            let newAlarmData = AlarmData()
            newAlarmData.alarmName = alarm.name ?? "Unknown"
            newAlarmData.items = convertItemsToAlarmDataItems(items: alarm.items as? Set<Items> ?? [])
            self.alarmManager.alarmData = newAlarmData
            self.alarmManager.tappedAlarm = true
                }
            } catch {
                print("Error fetching alarm: \(error)")
            }
        }

        completionHandler()
    }

    private func printItems(_ items: [AlarmData.Item], indentLevel: Int) {
        let indent = String(repeating: "    ", count: indentLevel)
        for item in items {
            print("\(indent)\(item.name) (중요도: \(item.importance))")
            if !item.children.isEmpty {
                printItems(item.children, indentLevel: indentLevel + 1)
            }
        }
    }

    
    private func convertItemsToAlarmDataItems(items: Set<Items>) -> [AlarmData.Item] {
            return items.map { item in
                AlarmData.Item(
                    name: item.name ?? "Unknown",
                    importance: item.importance,
                    children: convertItemsToAlarmDataItems(items: item.children as? Set<Items> ?? [])
                )
            }
        }
}



