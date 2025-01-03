//
//  PHQTest.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class PHQTest: Identifiable {
    var id: UUID
    var date: Date
    var answers: [Int]
    var totalScore: Int
    var severity: String
    
    init(answers: [Int]) {
        self.id = UUID()
        self.date = Date()
        self.answers = answers
        self.totalScore = answers.reduce(0, +)
        self.severity = PHQTest.calculateSeverity(score: answers.reduce(0, +))
    }
    
    static func calculateSeverity(score: Int) -> String {
        switch score {
        case 0:
            return "No depression"
        case 1...4:
            return "Minimal depression"
        case 5...9:
            return "Mild depression"
        case 10...14:
            return "Moderate depression"
        case 15...19:
            return "Moderately severe depression"
        default:
            return "Severe depression"
        }
    }
    
    func severityColor(severity: String) -> Color {
        switch severity {
        case "No depression":
            return Color.green
        case "Minimal depression":
            return Color.blue
        case "Mild depression":
            return Color.yellow.opacity(0.7)
        case "Moderate depression":
            return Color.orange
        case "Moderately severe depression":
            return Color.red
        default:
            return Color.purple
        }
    }
}

