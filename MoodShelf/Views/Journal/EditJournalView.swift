import SwiftUI
import SwiftData

struct EditJournalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let journal: Journal
    @State private var content: String
    @State private var journalType: JournalType
    @State private var bibleReference: String
    @State private var gratitudeTarget: String
    @State private var selectedEmotion: Emotion?
    
    init(journal: Journal) {
        self.journal = journal
        _content = State(initialValue: journal.content)
        _journalType = State(initialValue: journal.type)
        _bibleReference = State(initialValue: journal.bibleReference ?? "")
        _gratitudeTarget = State(initialValue: journal.gratitudeTarget ?? "")
        _selectedEmotion = State(initialValue: journal.emotionType)
    }
    
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
                                Text("Referenre")
                                    .font(.headline)
                                TextField("John 3:16", text: $bibleReference)
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
            .navigationTitle("Edit Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        updateJournal()
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
    
    private func updateJournal() {
        journal.content = content
        journal.type = journalType
        journal.emotionType = selectedEmotion
        journal.bibleReference = journalType == .bible ? bibleReference : nil
        journal.gratitudeTarget = journalType == .gratitude ? gratitudeTarget : nil
        
        try? modelContext.save()
        dismiss()
    }
} 
