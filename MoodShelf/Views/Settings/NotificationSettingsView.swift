//
//  NotificationSettingsView.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import SwiftUI
import SwiftData
import UserNotifications

struct NotificationSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notifications: [NotificationSetting]
    @State private var showAddNotification = false
    @State private var showSettingsAlert = false
    
    var body: some View {
        List {
            Group {
                if notifications.isEmpty {
                    ContentUnavailableView(
                        "No Schedule Reminder",
                        systemImage: "app.badge",
                        description: Text("Add reminders to help you track your mood and keep a journal.")
                    )
                    .symbolEffect(.bounce, value: notifications.isEmpty)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(notifications) { notification in
                        NotificationRow(notification: notification)
                    }
                    .onDelete(perform: deleteNotifications)
                }
            }
        }
        .navigationTitle("Schedule Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        let status = await NotificationManager.shared.checkAuthorizationStatus()
                        if status == .denied {
                            showSettingsAlert = true
                        } else if status == .authorized {
                            showAddNotification = true
                        } else {
                            let granted = await NotificationManager.shared.requestAuthorization()
                            if granted {
                                showAddNotification = true
                            } else {
                                showSettingsAlert = true
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "app.badge")
                            .rotationEffect(.degrees(5))
                        Text("Add")
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 14)
                    .background(.green)
                    .clipShape(Capsule())
                }
            }
        }
        .sheet(isPresented: $showAddNotification) {
            AddNotificationView()
        }
        .alert("Notifications Disabled",
               isPresented: $showSettingsAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        } message: {
            Text("Enable notifications in Settings to receive reminders")
        }
    }
    
    private func deleteNotifications(_ indexSet: IndexSet) {
        for index in indexSet {
            let notification = notifications[index]
            NotificationManager.shared.removeNotification(for: notification)
            modelContext.delete(notification)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
            .modelContainer(PreviewSampleData.shared.container)
    }
}
