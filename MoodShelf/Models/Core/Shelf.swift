//
//  Shelf.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import Foundation
import SwiftData

@Model
final class Shelf {
    var id: UUID
    var name: String
    var emoji: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var moodRecords: [MoodRecord]
    @Relationship(deleteRule: .cascade) var journals: [Journal]
    
    init(name: String, emoji: String) {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.createdAt = Date()
        self.moodRecords = []
        self.journals = []
    }
    
    func addMoodRecord(_ record: MoodRecord) {
        moodRecords.append(record)
    }
    
    func removeMoodRecord(_ record: MoodRecord) {
        if let index = moodRecords.firstIndex(where: { $0.id == record.id }) {
            moodRecords.remove(at: index)
        }
    }
} 
