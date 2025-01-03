//
//  MoodRecord.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import Foundation
import SwiftData

@Model
final class MoodRecord {
    var id: UUID
    var mood: MoodType
    var createdAt: Date
    var shelf: Shelf?
    
    init(mood: MoodType, shelf: Shelf? = nil) {
        self.id = UUID()
        self.mood = mood
        self.createdAt = Date()
        self.shelf = shelf
    }
}
