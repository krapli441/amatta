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
        content.title = "\(alarmName) 준비 시간입니다!"
        content.body = "놓고 간 물건이 있는지 확인해볼까요?"
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour, .minute], from: alarmTime)
        let weekdays = [alarm.sunday, alarm.monday, alarm.tuesday, alarm.wednesday, alarm.thursday, alarm.friday, alarm.saturday]

        for (index, day) in weekdays.enumerated() where day {
            dateComponents.weekday = index + 1  // 일요일은 1, 월요일은 2, ...
            scheduleNotification(for: dateComponents, with: content, identifier: "alarm_\(alarm.alarmIdentifier ?? UUID().uuidString)_\(index)")
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
