//
//  Emotion.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import Foundation
import SwiftUI

enum Emotion: String, CaseIterable {
    case happiness = "Happiness"
    case sadness = "Sadness"
    case anger = "Anger"
    case fear = "Fear"
    case surprise = "Surprise"
    case disgust = "Disgust"
    
    var color: Color {
        switch self {
        case .happiness: return .yellow
        case .sadness: return .blue
        case .anger: return .red
        case .fear: return .purple
        case .surprise: return .orange
        case .disgust: return .green
        }
    }
    
    var icon: String {
        switch self {
        case .happiness: return "face.smiling"
        case .sadness: return "cloud.rain"
        case .anger: return "flame"
        case .fear: return "exclamationmark.triangle"
        case .surprise: return "star.circle"
        case .disgust: return "heart"
        }
    }
}
