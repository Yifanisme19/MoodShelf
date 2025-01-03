import SwiftUI
import SwiftData
import Charts

struct ShelfDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddJournal = false
    @State private var showingAllJournals = false
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    let shelf: Shelf
    
    @Query(sort: \Journal.createdAt, order: .reverse) private var allJournals: [Journal]
    
    private var recentJournals: [Journal] {
        allJournals.filter { $0.shelf?.id == shelf.id }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    MoodRecordCard(onMoodSelected: { mood in
                        addMoodRecord(mood)
                    })
                    
                    MoodHeatmap(shelf: shelf)
                    
                    MoodAnalysisCard(shelf: shelf)
                    
                    MoodStatsCard(shelf: shelf)
                    
                    EmotionStatsView(shelf: shelf)
                    
                    // 日记部分
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Journal")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button {
                                showingAllJournals = true
                            } label: {
                                HStack {
                                    Text("All data")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                            }
                        }
                        
                        if recentJournals.isEmpty {
                            Text("Empty Journal")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            ForEach(recentJournals.prefix(3)) { journal in
                                NavigationLink(value: journal) {
                                    JournalRow(journal: journal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showingAddJournal = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(shelf.emoji)
                        .font(.title2)
                    Text(shelf.name)
                        .font(.headline)
                }
            }
            
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
        .sheet(isPresented: $showingAddJournal) {
            AddJournalView(shelf: shelf)
        }
        .sheet(isPresented: $showingAllJournals) {
            NavigationStack {
                JournalListView(shelf: shelf)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditShelfView(shelf: shelf)
        }
        .navigationDestination(for: Journal.self) { journal in
            JournalDetailView(journal: journal)
        }
        .alert("Delete Shelf", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteShelf()
            }
        } message: {
            Text("Are you sure you want to delete this shelf? This action cannot be undone.")
        }
    }
    
    private func deleteShelf() {
        modelContext.delete(shelf)
        dismiss()
    }
    
    private func addMoodRecord(_ type: MoodType) {
        let record = MoodRecord(mood: type, shelf: shelf)
        modelContext.insert(record)
    }
}

// 如果还没有JournalRowView，添加这个视图
struct JournalRowView: View {
    let journal: Journal
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(journal.content)
                .lineLimit(2)
                .font(.subheadline)
            
            Text(journal.createdAt, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        let preview = PreviewSampleData.shared
        ShelfDetailView(shelf: preview.sampleShelf1)
            .modelContainer(preview.container)
    }
}

#Preview("MoodRecordCard") {
    MoodRecordCard(onMoodSelected: { _ in })
        .padding()
        .background(Color(.systemGroupedBackground))
} 
