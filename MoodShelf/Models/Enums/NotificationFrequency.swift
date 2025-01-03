//
//  NotificationFrequency.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 18/12/2024.
//


// 通知频率枚举
enum NotificationFrequency: String, CaseIterable {
    case once = "Once"
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Bi-weekly"
    case monthly = "Monthly"
    
    var days: Int {
        switch self {
        case .once: return 0
        case .daily: return 1
        case .weekly: return 7
        case .biweekly: return 14
        case .monthly: return 30
        }
    }
}
