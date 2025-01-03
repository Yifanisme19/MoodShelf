import SwiftUI
import SwiftData

struct JournalsCard: View {
    let shelf: Shelf
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("日记")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Spacer()
                
                NavigationLink {
                    JournalListView(shelf: shelf)
                } label: {
                    Label("查看全部", systemImage: "chevron.right")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            ForEach(shelf.journals.sorted { $0.createdAt > $1.createdAt }) { journal in
                NavigationLink(value: journal) {
                    JournalRow(journal: journal)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
} 

#Preview {
    let preview = PreviewSampleData.shared
    return JournalsCard(shelf: preview.sampleShelf1)
        .padding()
        .background(Color(.systemGroupedBackground))
} 
