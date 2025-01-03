//
//  Journal.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import Foundation
import SwiftData

@Model
final class Journal {
    var id: UUID
    var type: JournalType
    var content: String
    var emotion: String?  
    var bibleReference: String?
    var gratitudeTarget: String?
    var createdAt: Date
    var shelf: Shelf?
    
    init(type: JournalType, content: String, emotion: Emotion? = nil, bibleReference: String? = nil, gratitudeTarget: String? = nil, shelf: Shelf? = nil) {
        self.id = UUID()
        self.type = type
        self.content = content
        self.emotion = emotion?.rawValue
        self.bibleReference = bibleReference
        self.gratitudeTarget = gratitudeTarget
        self.createdAt = Date()
        self.shelf = shelf
    }
    
    var emotionType: Emotion? {
        get {
            guard let emotion = emotion else { return nil }
            return Emotion(rawValue: emotion)
        }
        set {
            emotion = newValue?.rawValue
        }
    }
}

