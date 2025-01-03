import SwiftUI
import SwiftData

struct EditNotificationView: View {
    let setting: NotificationSetting
    
    var body: some View {
        NotificationFormView(mode: .edit, setting: setting)
    }
}

#Preview {
    EditNotificationView(setting: NotificationSetting(
        type: NotificationType.moodTracking.rawValue,
        time: Date()
    ))
    .modelContainer(PreviewSampleData.shared.container)
} 