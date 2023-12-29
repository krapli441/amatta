//
//  NotificationManager.swift
//  amatta
//
//  Created by 박준형 on 12/20/23.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func scheduleNotification(for alarm: Alarm) {
        guard let alarmName = alarm.name, let alarmTime = alarm.time else { return }
        
        let content = UNMutableNotificationContent()

        // Alarm의 items를 Items 타입의 배열로 변환
            if let itemsSet = alarm.items as? Set<Items>, !itemsSet.isEmpty {
                // 중요도가 가장 높은 물건을 찾음
                let mostImportantItem = itemsSet.sorted(by: { $0.importance > $1.importance }).first

                // 물건에 따라 제목과 본문을 다르게 설정
                if let item = mostImportantItem {
                    content.title = "혹시... \(item.name ?? "물건") 챙기셨나요?"
                    content.body = "\(alarmName) 준비하는데 꼭 필요한 물건이에요!"
                } else {
                    content.title = "\(alarmName) 준비 시간입니다!"
                    content.body = "놓고 간 물건이 있는지 확인해볼까요?"
                }
            } else {
                content.title = "\(alarmName) 준비 시간입니다!"
                content.body = "까먹은 건 없는지 확인해볼까요?"
            }
            content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour, .minute], from: alarmTime)
        let weekdays = [alarm.sunday, alarm.monday, alarm.tuesday, alarm.wednesday, alarm.thursday, alarm.friday, alarm.saturday]

        for (index, day) in weekdays.enumerated() where day {
            dateComponents.weekday = index + 1  // 일요일은 1, 월요일은 2, ...
            let identifier = "alarm_\(alarm.alarmIdentifier ?? UUID().uuidString)_\(index)"
            scheduleNotification(for: dateComponents, with: content, identifier: identifier)
        }
    }

    private func scheduleNotification(for dateComponents: DateComponents, with content: UNMutableNotificationContent, identifier: String) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 스케줄링 실패: \(error.localizedDescription)")
            } else {
                print("알림 스케줄링 성공: \(identifier)")
            }
        }
    }

}
