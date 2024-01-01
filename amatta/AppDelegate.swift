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
            // AlarmData 객체에 데이터 저장
            alarmData.alarmName = alarm.name ?? "Unknown"
            alarmData.items = convertItemsToAlarmDataItems(items: alarm.items as? Set<Items> ?? [])
                        
            // 필요한 경우, PushAlarmHeaderView로 이동하는 로직 추가
            // 예: SwiftUI 뷰에서 화면 전환 처리
            }
                } catch {
                    print("Error fetching alarm: \(error)")
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

//    private func printItem(_ item: Items, indentLevel: Int) {
//        let indent = String(repeating: "    ", count: indentLevel)
//        print("\(indent)\(item.name ?? "Unknown") (중요도: \(item.importance))")
//        
//        // 하위 물건들을 재귀적으로 출력
//        if let children = item.children as? Set<Items>, !children.isEmpty {
//            for child in children {
//                printItem(child, indentLevel: indentLevel + 1)
//            }
//        }
//    }


}



