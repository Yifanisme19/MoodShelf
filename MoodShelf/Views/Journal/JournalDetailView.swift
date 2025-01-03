import SwiftUI
import SwiftData

struct JournalDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let journal: Journal
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(journal.createdAt.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    if let emotion = journal.emotionType {
                        Text(emotion.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(emotion.color)
                    }
                }
                
                Text(journal.content)
                    .font(.body)
                
                if let reference = journal.bibleReference {
                    Text(reference)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                }
                
                if let target = journal.gratitudeTarget {
                    Text("Grateful for：\(target)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                EditJournalView(journal: journal)
            }
        }
        .alert("Are you sure you want to delete this journal?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteJournal()
            }
        }
    }
    
    private func deleteJournal() {
        modelContext.delete(journal)
        dismiss()
    }
} 
