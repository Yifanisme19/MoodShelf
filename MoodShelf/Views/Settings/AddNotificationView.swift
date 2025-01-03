//
//  AddNotificationView.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import SwiftUI
import SwiftData

struct AddNotificationView: View {
    var body: some View {
        NotificationFormView(mode: .create)
    }
}

#Preview {
    AddNotificationView()
        .modelContainer(PreviewSampleData.shared.container)
}
