import SwiftUI

struct AddJournalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let shelf: Shelf
    @State private var content: String = ""
    @State private var journalType: JournalType = .normal
    @State private var bibleReference: String = ""
    @State private var gratitudeTarget: String = ""
    @State private var selectedEmotion: Emotion?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 情绪选择器
                    EmotionPicker(selectedEmotion: $selectedEmotion)
                    
                    // 日记类型和内容
                    VStack(alignment: .leading, spacing: 16) {
                        Picker("Journal Type", selection: $journalType) {
                            ForEach(JournalType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Content")
                                .font(.headline)
                            TextEditor(text: $content)
                                .frame(minHeight: 150)
                                .padding(8)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                        }
                        
                        if journalType == .bible {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Reference")
                                    .font(.headline)
                                TextField("", text: $bibleReference)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        
                        if journalType == .gratitude {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Grateful for")
                                    .font(.headline)
                                TextField("Something to be grateful for", text: $gratitudeTarget)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                }
                .padding()
            }
            .navigationTitle("New Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveJournal()
                    }
                    .disabled(!isValidInput)
                }
            }
        }
    }
    
    private var isValidInput: Bool {
        guard !content.isEmpty, selectedEmotion != nil else { return false }
        
        switch journalType {
        case .bible:
            return !bibleReference.isEmpty
        case .gratitude:
            return !gratitudeTarget.isEmpty
        case .normal:
            return true
        }
    }
    
    private func saveJournal() {
        let journal = Journal(
            type: journalType,
            content: content,
            emotion: selectedEmotion,
            bibleReference: journalType == .bible ? bibleReference : nil,
            gratitudeTarget: journalType == .gratitude ? gratitudeTarget : nil,
            shelf: shelf
        )
        
        modelContext.insert(journal)
        dismiss()
    }
}

#Preview {
    AddJournalView(shelf: PreviewSampleData.shared.sampleShelf1)
        .modelContainer(PreviewSampleData.shared.container)
} 
