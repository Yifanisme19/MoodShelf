import SwiftUI
import SwiftData

struct MoodHeatmap: View {
    let shelf: Shelf
    @Environment(\.modelContext) private var modelContext
    @Query private var moodRecords: [MoodRecord]
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    @State private var selectedDate: Date?
    
    private let calendar = Calendar.current
    
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
    
    var moodData: [[(Date, [MoodRecord])]] {
        let today = Date()
        let currentMonth = calendar.component(.month, from: today)
        let currentYear = calendar.component(.year, from: today)
        
        // 获取当前月的天数
        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)),
              let daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)?.count else {
            return []
        }
        
        let recordDict = Dictionary(grouping: moodRecords) { record in
            calendar.startOfDay(for: record.createdAt)
        }
        
        var weeklyData: [[(Date, [MoodRecord])]] = []
        var currentWeek: [(Date, [MoodRecord])] = []
        
        for day in 0..<daysInMonth {
            guard let date = calendar.date(byAdding: .day, value: day, to: firstDayOfMonth) else {
                continue
            }
            
            let records = recordDict[calendar.startOfDay(for: date)] ?? []
            currentWeek.append((date, records))
            
            if currentWeek.count == 7 {
                weeklyData.append(currentWeek)
                currentWeek = []
            }
        }
        
        // 处理最后不完整的一周
        if !currentWeek.isEmpty {
            weeklyData.append(currentWeek)
        }
        
        return weeklyData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 标题和图例
            HStack {
                Text("\(shelf.emoji) \(shelf.name)")
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Text("Positive")
                            .font(.caption)
                    }
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.red.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Text("Negative")
                            .font(.caption)
                    }
                }
                .foregroundStyle(.secondary)
            }
            
            // 热力图
            VStack(alignment: .leading, spacing: 4) {
                // 日期标签
                HStack(spacing: 4) {
                    Text("Week")
                        .frame(width: 40, alignment: .leading)
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                    }
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
                
                // 每周数据
                ForEach(Array(moodData.enumerated()), id: \.offset) { weekIndex, week in
                    HStack(spacing: 4) {
                        Text("W\(weekIndex + 1)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                            .frame(width: 40, alignment: .leading)
                        
                        ForEach(0..<7, id: \.self) { dayIndex in
                            if let dayData = week.first(where: { Calendar.current.component(.weekday, from: $0.0) == dayIndex + 1 }) {
                                DayCell(date: dayData.0, records: dayData.1)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedDate = selectedDate == dayData.0 ? nil : dayData.0
                                        }
                                    }
                            } else {
                                // Fill empty days with a placeholder
                                DayCell(date: nil, records: [])
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // 选中日期的详细信息
            if let date = selectedDate,
               let dayRecords = moodData.flatMap({ $0 }).first(where: { $0.0 == date })?.1,
               !dayRecords.isEmpty {
                HStack(spacing: 16) {
                    Text(date.formatted(date: .long, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    let positiveCount = dayRecords.filter { $0.mood == .positive }.count
                    let negativeCount = dayRecords.filter { $0.mood == .negative }.count
                    
                    Label("\(positiveCount)", systemImage: "sun.max.fill")
                        .foregroundStyle(.green)
                    
                    Label("\(negativeCount)", systemImage: "cloud.rain.fill")
                        .foregroundStyle(.red)
                }
                .font(.caption)
                .padding(.vertical, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

private struct DayCell: View {
    let date: Date?
    let records: [MoodRecord]
    
    var body: some View {
        if records.isEmpty {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray6))
                .aspectRatio(1, contentMode: .fit)
        } else {
            let positiveCount = records.filter { $0.mood == .positive }.count
            let negativeCount = records.filter { $0.mood == .negative }.count
            
            RoundedRectangle(cornerRadius: 4)
                .fill(positiveCount >= negativeCount ? .green.opacity(0.3) : .red.opacity(0.3))
                .overlay(
                    Text("\(records.count)")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .opacity(records.count > 1 ? 1 : 0)
                )
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

#Preview {
    MoodHeatmap(shelf: PreviewSampleData.shared.sampleShelf1)
        .padding()
        .background(Color(.systemGroupedBackground))
}

