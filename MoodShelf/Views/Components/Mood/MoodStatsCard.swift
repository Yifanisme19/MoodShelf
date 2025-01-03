import SwiftUI
import SwiftData
import Charts

struct MoodStatsCard: View {
    let shelf: Shelf
    @Query private var moodRecords: [MoodRecord]
    @State private var timeRange: TimeRange = .week
    @State private var showingAllRecords = false
    @Environment(\.modelContext) private var modelContext
    
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
    
    enum TimeRange: String, CaseIterable {
        case week = "Weekday"
        case month = "Month"
        case year = "Year"
        
        var dateInterval: (start: Date, end: Date) {
            let calendar = Calendar.current
            let now = Date()
            
            switch self {
            case .week:
                let today = calendar.startOfDay(for: now)
                let weekday = calendar.component(.weekday, from: today)
                let weekdayOffset = 1 - weekday
                let startDate = calendar.date(byAdding: .day, value: weekdayOffset, to: today)!
                let endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
                return (startDate, endDate)
                
            case .month:
                let endDate = now
                let startDate = calendar.date(byAdding: .month, value: -11, to: calendar.startOfMonth(for: now))!
                return (startDate, endDate)
                
            case .year:
                let endDate = now
                let startDate = calendar.date(byAdding: .year, value: -2, to: calendar.startOfYear(for: now))!
                return (startDate, endDate)
            }
        }
        
        func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            
            switch self {
            case .week:
                formatter.dateFormat = "EEE"
                return formatter.string(from: date)
            case .month:
                formatter.dateFormat = "MMM"
                return formatter.string(from: date)
            case .year:
                formatter.dateFormat = "yyyy"
                return formatter.string(from: date)
            }
        }
    }
    
    struct DayMood: Identifiable {
        let id: Date
        let date: Date
        let positive: Int
        let negative: Int
    }
    
    struct MoodValue: Identifiable {
        let id = UUID()
        let date: Date
        let type: String
        let value: Int
    }
    
    var moodData: [DayMood] {
        let interval = timeRange.dateInterval
        let filteredRecords = moodRecords.filter { record in
            record.createdAt >= interval.start && record.createdAt <= interval.end
        }
        
        var result: [DayMood] = []
        let calendar = Calendar.current
        
        switch timeRange {
        case .week:
            for day in 0...6 {
                let date = calendar.date(byAdding: .day, value: day, to: interval.start)!
                let dayStart = calendar.startOfDay(for: date)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let dayRecords = filteredRecords.filter { record in
                    record.createdAt >= dayStart && record.createdAt < dayEnd
                }
                
                let positive = dayRecords.filter { $0.mood == .positive }.count
                let negative = dayRecords.filter { $0.mood == .negative }.count
                
                result.append(DayMood(id: dayStart, date: dayStart, positive: positive, negative: negative))
            }
            
        case .month:
            var date = interval.start
            while date <= interval.end {
                let monthStart = calendar.startOfMonth(for: date)
                let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!
                
                let monthRecords = filteredRecords.filter { record in
                    record.createdAt >= monthStart && record.createdAt < monthEnd
                }
                
                let positive = monthRecords.filter { $0.mood == .positive }.count
                let negative = monthRecords.filter { $0.mood == .negative }.count
                
                result.append(DayMood(id: monthStart, date: monthStart, positive: positive, negative: negative))
                date = monthEnd
            }
            
        case .year:
            var date = interval.start
            while date <= interval.end {
                let yearStart = calendar.startOfYear(for: date)
                let yearEnd = calendar.date(byAdding: .year, value: 1, to: yearStart)!
                
                let yearRecords = filteredRecords.filter { record in
                    record.createdAt >= yearStart && record.createdAt < yearEnd
                }
                
                let positive = yearRecords.filter { $0.mood == .positive }.count
                let negative = yearRecords.filter { $0.mood == .negative }.count
                
                result.append(DayMood(id: yearStart, date: yearStart, positive: positive, negative: negative))
                date = yearEnd
            }
        }
        
        return result
    }
    
    var chartData: [MoodValue] {
        moodData.flatMap { day in
            [
                MoodValue(date: day.date, type: "Positive", value: day.positive),
                MoodValue(date: day.date, type: "Negative", value: day.negative)
            ]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Mood Statistics")
                    .font(.headline)
                
                Spacer()
                
                if !moodRecords.isEmpty {
                    Button {
                        showingAllRecords = true
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
            }
            
            Picker("Time", selection: $timeRange) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            
            if !moodData.isEmpty {
                Chart(chartData) { item in
                    BarMark(
                        x: .value("Date", item.date),
                        y: .value("Count", item.value)
                    )
                    .foregroundStyle(by: .value("Type", item.type))
                    .position(by: .value("Type", item.type))
                }
                .chartForegroundStyleScale([
                    "Positive": Color.green.opacity(0.7),
                    "Negative": Color.red.opacity(0.7)
                ])
                .chartXAxis {
                    switch timeRange {
                    case .week:
                        AxisMarks(preset: .aligned, values: .stride(by: .day)) { value in
                            if let date = value.as(Date.self) {
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    Text(timeRange.formatDate(date))
                                        .font(.caption)
                                        .fixedSize()
                                        .textCase(.uppercase)
                                }
                            }
                        }
                    case .month:
                        AxisMarks(preset: .aligned, values: .stride(by: .month)) { value in
                            if let date = value.as(Date.self) {
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    Text(timeRange.formatDate(date))
                                        .font(.caption)
                                        .fixedSize()
                                        .textCase(.uppercase)
                                }
                            }
                        }
                    case .year:
                        AxisMarks(preset: .aligned, values: .stride(by: .year)) { value in
                            if let date = value.as(Date.self) {
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    Text(timeRange.formatDate(date))
                                        .font(.caption)
                                        .fixedSize()
                                }
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let number = value.as(Int.self) {
                                Text("\(number)")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .chartLegend(position: .top)
                .frame(height: 250)
                .padding(.vertical)
                
                HStack(spacing: 20) {
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.green.opacity(0.7))
                            .frame(width: 16, height: 16)
                        Text("Positive")
                    }
                    
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.red.opacity(0.7))
                            .frame(width: 16, height: 16)
                        Text("Negative")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                
            } else {
                Text("No mood record")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showingAllRecords) {
            NavigationStack {
                List {
                    ForEach(moodRecords) { record in
                        HStack {
                            Image(systemName: record.mood == .positive ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                                .foregroundStyle(record.mood == .positive ? .green : .red)
                            
                            Text(record.createdAt.formatted(date: .abbreviated, time: .shortened))
                            
                            Spacer()
                            
                            Text(record.mood == .positive ? "Positive" : "Negative")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteRecords)
                }
                .navigationTitle("All Recorded Mood")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            showingAllRecords = false
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
    
    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            let recordToDelete = moodRecords[index]
            modelContext.delete(recordToDelete)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving context after deletion: \(error)")
        }
    }
}

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
    
    func startOfYear(for date: Date) -> Date {
        let components = dateComponents([.year], from: date)
        return self.date(from: components)!
    }
}

#Preview {
    MoodStatsCard(shelf: PreviewSampleData.shared.sampleShelf1)
        .padding()
        .background(Color(.systemGroupedBackground))
} 
