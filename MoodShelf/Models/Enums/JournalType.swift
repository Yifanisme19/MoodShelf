//
//  JournalType.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import Foundation
import SwiftUICore

enum JournalType: String, Codable, CaseIterable {
    case normal = "Diary"
    case bible = "Bible"
    case gratitude = "Gratitude"
    
    var color: Color {
        switch self {
            case .normal: return .blue
            case .bible: return .red
            case .gratitude: return .green
        }
    }
}
