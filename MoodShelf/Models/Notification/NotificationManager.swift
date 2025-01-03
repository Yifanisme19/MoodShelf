//
//  NotificationManager.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() async -> Bool {
        do {
            let options: UNAuthorizationOptions = [.alert, .sound]
            return try await UNUserNotificationCenter.current().requestAuthorization(options: options)
        } catch {
            print("Error requesting authorization: \(error.localizedDescription)")
            return false
        }
    }
    
    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }
    
    func scheduleNotification(for setting: NotificationSetting) async {
        let content = UNMutableNotificationContent()
        content.title = setting.notificationType.randomNotificationTitle
        content.body = setting.notificationType.randomNotificationBody
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: setting.time)
        
        // 根据频率设置重复规则
        var dateComponents = DateComponents()
        dateComponents.hour = components.hour
        dateComponents.minute = components.minute
        
        let trigger: UNNotificationTrigger
        
        switch setting.notificationFrequency {
        case .once:
            // 一次性通知，使用 UNCalendarNotificationTrigger 但不重复
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
        case .daily:
            // 每天重复
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
        case .weekly:
            // 设置每周的特定一天
            dateComponents.weekday = calendar.component(.weekday, from: setting.time)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
        case .biweekly:
            // 每两周重复
            let weekOfYear = calendar.component(.weekOfYear, from: setting.time)
            dateComponents.weekOfYear = weekOfYear + (weekOfYear % 2 == 0 ? 0 : 1)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
        case .monthly:
            // 设置每月的特定日期
            dateComponents.day = calendar.component(.day, from: setting.time)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        }
        
        let request = UNNotificationRequest(
            identifier: setting.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Error scheduling notification: \(error.localizedDescription)")
        }
    }
    
    func removeNotification(for setting: NotificationSetting) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [setting.id.uuidString])
    }
    
    func updateNotification(for setting: NotificationSetting) async {
        removeNotification(for: setting)
        await scheduleNotification(for: setting)
    }
}
