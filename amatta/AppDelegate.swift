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
    var tappedAlarm: Bool = false

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
            // PushAlarmScreenView로 이동
            tappedAlarm = true
            print("tappedAlarm is now true")
        }
        completionHandler()
    }


    // CoreData에서 알림 정보를 조회하는 메소드
    private func fetchAlarm(with identifier: String) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Alarm>(entityName: "Alarm")
        fetchRequest.predicate = NSPredicate(format: "alarmIdentifier == %@", identifier)

        do {
            let alarms = try context.fetch(fetchRequest)
            if let alarm = alarms.first {
                alarmData.alarmName = alarm.name ?? "Unknown"
                alarmData.items = convertItemsToAlarmDataItems(items: alarm.items as? Set<Items> ?? [])

                // AlarmData 객체에 저장된 정보 출력
                print("Stored Alarm Data:")
                print("Alarm Name: \(alarmData.alarmName)")
                printItems(alarmData.items, indentLevel: 0)
            }
        } catch {
            print("Error fetching alarm: \(error)")
        }
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



