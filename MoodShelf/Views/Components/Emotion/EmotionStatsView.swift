import SwiftUI
import SwiftData

struct EmotionStatsView: View {
    let shelf: Shelf
    @Query private var journals: [Journal]
    
    init(shelf: Shelf) {
        self.shelf = shelf
        let shelfId = shelf.id
        _journals = Query(
            filter: #Predicate<Journal> { journal in
                journal.shelf?.id == shelfId
            }
        )
    }
    
    var emotionStats: [(Emotion, Int)] {
        var stats: [Emotion: Int] = [:]
        
        // 初始化所有情绪的计数为0
        for emotion in Emotion.allCases {
            stats[emotion] = 0
        }
        
        // 统计每种情绪的数量
        for journal in journals {
            if let emotion = journal.emotionType {
                stats[emotion, default: 0] += 1
            }
        }
        
        // 转换为数组并按数量排序
        return stats.sorted { $0.value > $1.value }
    }
    
    var totalJournals: Int {
        journals.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emotion Distribution")
                .font(.headline)
            
            if totalJournals > 0 {
                // 情绪圆圈网格
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 16)
                ], spacing: 16) {
                    ForEach(emotionStats, id: \.0) { emotion, count in
                        EmotionCircle(
                            emotion: emotion,
                            count: count,
                            total: totalJournals
                        )
                    }
                }
            } else {
                Text("No emotion records yet")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// 情绪圆圈组件
private struct EmotionCircle: View {
    let emotion: Emotion
    let count: Int
    let total: Int
    
    @State private var isAnimated = false
    
    private var percentage: Double {
        Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // 背景圆圈
                Circle()
                    .stroke(emotion.color.opacity(0.2), lineWidth: 8)
                
                // 进度圆圈
                Circle()
                    .trim(from: 0, to: isAnimated ? percentage / 100 : 0)
                    .stroke(
                        emotion.color,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                
                // 使用现有的 EmotionFlower
                OverlappingCirclesFlowerView(color: emotion.color)
                    .frame(width: 40, height: 40)
                    .scaleEffect(isAnimated ? 1 : 0.5)
            }
            .frame(width: 80, height: 80)
            
            // 文字信息
            VStack(spacing: 4) {
                Text(emotion.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(Int(percentage))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    VStack {
        EmotionStatsView(shelf: PreviewSampleData.shared.sampleShelf1)
            .padding()
        
        EmotionStatsView(shelf: PreviewSampleData.shared.sampleShelf2)
            .padding()
            .preferredColorScheme(.dark)
    }
    .background(Color(.systemGroupedBackground))
} 
