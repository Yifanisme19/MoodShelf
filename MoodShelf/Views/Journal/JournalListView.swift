import SwiftUI
import SwiftData

struct JournalListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var journals: [Journal]
    
    @State private var searchText = ""
    @State private var selectedType: JournalType?
    @State private var selectedEmotion: Emotion?
    
    init(shelf: Shelf) {
        let shelfId = shelf.id
        _journals = Query(
            filter: #Predicate<Journal> { journal in
                journal.shelf?.id == shelfId
            },
            sort: \Journal.createdAt,
            order: .reverse
        )
    }
    
    var filteredJournals: [Journal] {
        journals.filter { journal in
            let matchesSearch = searchText.isEmpty || 
                journal.content.localizedCaseInsensitiveContains(searchText) ||
                (journal.bibleReference?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (journal.gratitudeTarget?.localizedCaseInsensitiveContains(searchText) ?? false)
            
            let matchesType = selectedType == nil || journal.type == selectedType
            let matchesEmotion = selectedEmotion == nil || journal.emotionType == selectedEmotion
            
            return matchesSearch && matchesType && matchesEmotion
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 筛选器
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "Type",
                        isSelected: selectedType == nil,
                        color: .gray
                    ) {
                        withAnimation { selectedType = nil }
                    }
                    
                    ForEach(JournalType.allCases, id: \.self) { type in
                        FilterChip(
                            title: type.rawValue,
                            isSelected: selectedType == type,
                            color: type.color
                        ) {
                            withAnimation { selectedType = type }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "Emotion",
                        isSelected: selectedEmotion == nil,
                        color: .gray
                    ) {
                        withAnimation { selectedEmotion = nil }
                    }
                    
                    ForEach(Emotion.allCases, id: \.self) { emotion in
                        FilterChip(
                            title: emotion.rawValue,
                            isSelected: selectedEmotion == emotion,
                            color: emotion.color
                        ) {
                            withAnimation { selectedEmotion = emotion }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            List {
                ForEach(filteredJournals) { journal in
                    NavigationLink {
                        JournalDetailView(journal: journal)
                    } label: {
                        JournalRow(journal: journal)
                    }
                }
                .onDelete(perform: deleteJournals)
            }
            .listStyle(.inset)
        }
        .navigationTitle("All Journal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search for content, bible, or gratitude for")
    }
    
    private func deleteJournals(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredJournals[index])
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(isSelected ? color : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(color.opacity(isSelected ? 0.1 : 0))
                        .strokeBorder(isSelected ? color : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        let preview = PreviewSampleData.shared
        JournalListView(shelf: preview.sampleShelf1)
            .modelContainer(preview.container)
    }
} 
