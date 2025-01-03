//
//  NotificationRow.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import SwiftUI

struct NotificationRow: View {
    @Bindable var notification: NotificationSetting
    @State private var showingEditSheet = false
    
    var body: some View {
        Button {
            showingEditSheet = true
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(notification.type)
                        .font(.headline)
                    Text(notification.time.formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Toggle("", isOn: $notification.isEnabled)
                    .onChange(of: notification.isEnabled) {
                        if notification.isEnabled {
                            Task {
                                await NotificationManager.shared.scheduleNotification(for: notification)
                            }
                        } else {
                            NotificationManager.shared.removeNotification(for: notification)
                        }
                    }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingEditSheet) {
            EditNotificationView(setting: notification)
        }
    }
}

#Preview {
    NotificationRow(notification: NotificationSetting(
        type: NotificationType.moodTracking.rawValue,
        time: Date()
    ))
}
