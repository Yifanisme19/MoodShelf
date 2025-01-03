//
//  MoodShelfApp.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import SwiftUI
import SwiftData

@main
struct MoodShelfApp: App {
    var container: ModelContainer = {
        let schema = Schema([
            Shelf.self,
            MoodRecord.self,
            PHQTest.self,
            Journal.self,
            NotificationSetting.self,
            DASS21Test.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
//    init() {
//        do {
//            let schema = Schema([
//                Shelf.self,
//                Journal.self,
//                MoodRecord.self,
//                PHQTest.self,
//                NotificationSetting.self,
//            ])
//            
//            #if DEBUG
//            let modelConfiguration = ModelConfiguration(
//                schema: schema,
//                isStoredInMemoryOnly: true
//            )
//            #else
//            let modelConfiguration = ModelConfiguration(
//                schema: schema,
//                isStoredInMemoryOnly: false
//            )
//            #endif
//
//            container = try ModelContainer(
//                for: schema,
//                configurations: modelConfiguration
//            )
//        } catch {
//            fatalError("Could not initialize ModelContainer: \(error)")
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
