//
//  NotificationSetting.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import Foundation
import SwiftData

@Model
class NotificationSetting {
    var id: UUID
    var type: String
    var time: Date
    var isEnabled: Bool
    var frequency: String  // 存储 NotificationFrequency 的 rawValue
    
    init(type: String, time: Date, frequency: NotificationFrequency = .daily, isEnabled: Bool = true) {
        self.id = UUID()
        self.type = type
        self.time = time
        self.frequency = frequency.rawValue
        self.isEnabled = isEnabled
    }
    
    var notificationType: NotificationType {
        NotificationType(rawValue: type) ?? .moodTracking
    }
    
    var notificationFrequency: NotificationFrequency {
        NotificationFrequency(rawValue: frequency) ?? .daily
    }
}
