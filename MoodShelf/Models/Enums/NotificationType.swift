//
//  NotificationType.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import Foundation

enum NotificationType: String, CaseIterable, Identifiable {
    case moodTracking = "Mood Tracking"
    case journaling = "Journaling"
    case phqReminder = "PHQ-9 Assessment"
    
    var id: String { self.rawValue }
    
    // 为每种类型准备多个提示语模板
    var notificationTitles: [String] {
        switch self {
        case .moodTracking:
            return [
                "Time to Track Your Mood",
                "How Are You Feeling?",
                "Quick Mood Check-in",
                "Moment of Reflection"
            ]
        case .journaling:
            return [
                "Time for Journaling",
                "Ready to Write?",
                "Capture Your Thoughts",
                "Express Yourself"
            ]
        case .phqReminder:
            return [
                "Time for Mental Health Check",
                "PHQ-9 Assessment Due",
                "Regular Health Check-in",
                "Wellness Assessment Time"
            ]
        }
    }
    
    var notificationBodies: [String] {
        switch self {
        case .moodTracking:
            return [
                "How are you feeling right now?",
                "Take a moment to record your mood",
                "A quick check-in can make a difference",
                "Your emotional well-being matters"
            ]
        case .journaling:
            return [
                "Take a moment to reflect on your day",
                "Your journal is waiting for your thoughts",
                "Writing can help clear your mind",
                "Document your journey"
            ]
        case .phqReminder:
            return [
                "It's time for your regular mental health assessment",
                "Regular check-ins help maintain good mental health",
                "Take a few minutes for your mental wellness",
                "Stay on top of your mental health"
            ]
        }
    }
    
    // 随机获取标题和内容
    var randomNotificationTitle: String {
        notificationTitles.randomElement() ?? notificationTitles[0]
    }
    
    var randomNotificationBody: String {
        notificationBodies.randomElement() ?? notificationBodies[0]
    }
    
    // 推荐的通知频率
    var recommendedFrequency: NotificationFrequency {
        switch self {
        case .moodTracking:
            return .daily
        case .journaling:
            return .daily
        case .phqReminder:
            return .biweekly
        }
    }
    
    // 推荐的通知时间
    var recommendedTime: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        
        switch self {
        case .moodTracking:
            // 推荐早上9点
            components.hour = 9
            components.minute = 0
        case .journaling:
            // 推荐晚上8点
            components.hour = 20
            components.minute = 0
        case .phqReminder:
            // 推荐下午3点
            components.hour = 15
            components.minute = 0
        }
        
        return calendar.date(from: components) ?? Date()
    }
}

