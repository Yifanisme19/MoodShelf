import SwiftUI

struct JournalRow: View {
    let journal: Journal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // 日记类型标签
                Text(journal.type.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(journal.type.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(journal.type.color.opacity(0.1))
                    .cornerRadius(6)
                
                Spacer()
                
                // 情绪标签
                if let emotion = journal.emotionType {
                    HStack(spacing: 4) {
//                        Image(systemName: emotion.icon)
                        Text(emotion.rawValue)
                    }
                    .font(.subheadline)
                    .foregroundStyle(emotion.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(emotion.color.opacity(0.1))
                    .cornerRadius(6)
                }
            }
            
            Text(journal.content)
                .font(.body)
                .lineLimit(2)
            
            if let reference = journal.bibleReference {
                Text("Reference：\(reference)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if let target = journal.gratitudeTarget {
                Text("Target：\(target)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(journal.createdAt.formatted())
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
} 
