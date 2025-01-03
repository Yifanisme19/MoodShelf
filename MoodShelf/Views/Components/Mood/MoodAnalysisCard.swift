import SwiftUI
import SwiftData

struct MoodAnalysisCard: View {
    let shelf: Shelf
    @Query private var moodRecords: [MoodRecord]
    
    init(shelf: Shelf) {
        self.shelf = shelf
        let shelfId = shelf.id
        _moodRecords = Query(
            filter: #Predicate<MoodRecord> { record in
                record.shelf?.id == shelfId
            },
            sort: \MoodRecord.createdAt,
            order: .reverse
        )
    }
    
    private var totalRecords: Int {
        moodRecords.count
    }
    
    private var positivePercentage: Double {
        guard totalRecords > 0 else { return 0 }
        let positiveCount = moodRecords.filter { $0.mood == .positive }.count
        return Double(positiveCount) / Double(totalRecords) * 100
    }
    
    private var streakDays: Int {
        var currentStreak = 0
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // 按日期分组记录
        let recordsByDate = Dictionary(grouping: moodRecords) {
            calendar.startOfDay(for: $0.createdAt)
        }
        
        var currentDate = today
        
        // 修改检查逻辑
        while recordsByDate[currentDate] != nil {
            // 如果当天有记录，增加连续天数
            currentStreak += 1
            // 检查前一天
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousDate
        }
        
        return currentStreak
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题
            Text("Mood Analysis")
                .font(.headline)
            
            // 统计数据
            HStack(spacing: 24) {
                // 总记录数
                StatItem(
                    title: "Total",
                    value: "\(totalRecords)",
                    icon: "list.bullet.clipboard",
                    iconColor: .blue
                )
                
                // 积极情绪百分比
                StatItem(
                    title: "Positive",
                    value: String(format: "%.0f%%", positivePercentage),
                    icon: "chart.pie",
                    iconColor: .green
                )
                
                // 连续记录天数
                StatItem(
                    title: "Streak",
                    value: "\(streakDays)d",
                    icon: "flame",
                    iconColor: .orange
                )
            }
            
            // 最近趋势图
            if !moodRecords.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Trend")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    GeometryReader { geometry in
                        TrendLine(records: Array(moodRecords.prefix(7)), width: geometry.size.width)
                    }
                    .frame(height: 40)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

private struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct TrendLine: View {
    let records: [MoodRecord]
    let width: CGFloat
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(records) { record in
                RoundedRectangle(cornerRadius: 8)
                    .fill(record.mood == .positive ? Color.green : Color.red)
                    .opacity(0.3)
                    .frame(width: (width - CGFloat(records.count - 1) * 4) / CGFloat(records.count))
            }
        }
    }
}

#Preview {
    MoodAnalysisCard(shelf: PreviewSampleData.shared.sampleShelf1)
        .padding()
        .background(Color(.systemGroupedBackground))
} 
