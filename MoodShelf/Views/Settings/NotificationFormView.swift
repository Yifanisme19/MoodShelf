import SwiftUI
import SwiftData

struct NotificationFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let mode: FormMode
    let existingSetting: NotificationSetting?
    
    @State private var type: NotificationType
    @State private var time: Date
    @State private var frequency: NotificationFrequency
    @State private var isEnabled: Bool
    @State private var showingPreview = false
    
    enum FormMode {
        case create
        case edit
        
        var title: String {
            switch self {
            case .create: return "Add Notification"
            case .edit: return "Edit Notification"
            }
        }
    }
    
    init(mode: FormMode, setting: NotificationSetting? = nil) {
        self.mode = mode
        self.existingSetting = setting
        
        let setting = setting ?? NotificationSetting(
            type: NotificationType.moodTracking.rawValue,
            time: Date(),
            frequency: .daily
        )
        
        _type = State(initialValue: setting.notificationType)
        _time = State(initialValue: setting.time)
        _frequency = State(initialValue: setting.notificationFrequency)
        _isEnabled = State(initialValue: setting.isEnabled)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Type", selection: $type) {
                        ForEach(NotificationType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(NotificationFrequency.allCases, id: \.self) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }
                    
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    
                    Toggle("Enabled", isOn: $isEnabled)
                }
                
                Section {
                    Button("Use Recommended Time") {
                        time = type.recommendedTime
                        frequency = type.recommendedFrequency
                    }
                    
                    Button("Preview Notification") {
                        showingPreview = true
                    }
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveChanges()
                        }
                    }
                }
            }
            .alert("Notification Preview", isPresented: $showingPreview) {
                Button("OK", role: .cancel) { }
            } message: {
                VStack(alignment: .leading, spacing: 8) {
                    Text(type.randomNotificationTitle)
                        .font(.headline)
                    Text(type.randomNotificationBody)
                        .font(.subheadline)
                }
            }
        }
    }
    
    private func saveChanges() async {
        switch mode {
        case .create:
            // 创建新的通知设置
            let newSetting = NotificationSetting(
                type: type.rawValue,
                time: time,
                frequency: frequency,
                isEnabled: isEnabled
            )
            modelContext.insert(newSetting)
            
            if isEnabled {
                await NotificationManager.shared.scheduleNotification(for: newSetting)
            }
            
        case .edit:
            guard let setting = existingSetting else { return }
            
            // 创建新的通知设置
            let newSetting = NotificationSetting(
                type: type.rawValue,
                time: time,
                frequency: frequency,
                isEnabled: isEnabled
            )
            
            modelContext.insert(newSetting)
            
            // 删除旧的通知设置
            NotificationManager.shared.removeNotification(for: setting)
            modelContext.delete(setting)
            
            // 设置新的通知
            if isEnabled {
                await NotificationManager.shared.scheduleNotification(for: newSetting)
            }
        }
        
        dismiss()
    }
} 