//
//  SettingsView.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import SwiftUI
import SwiftData
import UserNotifications

struct SettingsView: View {
    var body: some View {
        List {
            Section {
                NavigationLink {
                    NotificationSettingsView()
                } label: {
                    Label("Notifications", systemImage: "bell")
                }
            } footer: {
                Text("Add notifications to get reminders for tracking your mood and journaling")
            } /// notifications
            
            Section("Contact Us") {
                NavigationLink {
                    AboutDeveloperView()
                } label: {
                    Label("About Developer", systemImage: "person")
                }
                
                Button(action: openMail) {
                    Label("Send Email", systemImage: "envelope")
                }
            }
            
            Section {
                Link(destination: URL(string: "https://gentle-fiber-2fc.notion.site/MoodShelf-Privacy-Policy-12d717cb29ce80b0824df1e65af62d29?pvs=4")!) {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
                
                Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                    Label("Terms Of Use", systemImage: "list.bullet.rectangle")
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    private func openMail() {
        let email = "leeyifan19@gmail.com"
        let subject = "Feedback | MoodShelf"
        let body = "Hello, I would like to provide feedback about"
        
        // URL encode the subject and body
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Construct the mailto URL
        if let mailURL = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            if UIApplication.shared.canOpenURL(mailURL) {
                UIApplication.shared.open(mailURL)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
