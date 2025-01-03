import SwiftUI
import SwiftData

struct DASS21HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DASS21Test.date, order: .reverse) private var tests: [DASS21Test]
    
    var body: some View {
        List {
            if !tests.isEmpty {
                Section {
                    DASS21AnalysisCard(tests: tests)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden)
            }
            
            Section {
                Text("Count: \(tests.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if tests.isEmpty {
                    ContentUnavailableView(
                        "No assessment record",
                        systemImage: "chart.bar.doc.horizontal",
                        description: Text("After completing a DASS-21 questionnaire, the record will be displayed here")
                    )
                } else {
                    ForEach(tests) { test in
                        NavigationLink {
                            DASS21TestDetailView(test: test)
                        } label: {
                            DASS21TestRow(test: test)
                        }
                    }
                    .onDelete(perform: deleteTests)
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !tests.isEmpty {
                EditButton()
            }
        }
    }
    
    private func deleteTests(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tests[index])
            }
        }
    }
}

// 分析卡片组件
struct DASS21AnalysisCard: View {
    let tests: [DASS21Test]
    
    // 计算最近趋势
    private var recentTrends: (depression: Double?, anxiety: Double?, stress: Double?) {
        guard tests.count >= 2 else { return (nil, nil, nil) }
        let latest = tests[0]
        let previous = tests[1]
        return (
            Double(latest.depressionScore - previous.depressionScore),
            Double(latest.anxietyScore - previous.anxietyScore),
            Double(latest.stressScore - previous.stressScore)
        )
    }
    
    // 计算平均分数
    private var averageScores: (depression: Double, anxiety: Double, stress: Double) {
        guard !tests.isEmpty else { return (0, 0, 0) }
        let depressionSum = tests.reduce(0) { $0 + $1.depressionScore }
        let anxietySum = tests.reduce(0) { $0 + $1.anxietyScore }
        let stressSum = tests.reduce(0) { $0 + $1.stressScore }
        let count = Double(tests.count)
        
        return (
            Double(depressionSum) / count,
            Double(anxietySum) / count,
            Double(stressSum) / count
        )
    }
    
    // 计算建议的下次测试时间
    private var suggestedNextTest: Date? {
        guard let lastTest = tests.first?.date else { return nil }
        return Calendar.current.date(byAdding: .day, value: 14, to: lastTest)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // 基础统计卡片
            VStack(spacing: 20) {
                // 标题
                HStack {
                    Text("Statistics")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                
                // 基础统计数据
                HStack(spacing: 24) {
                    StatItemView(
                        title: "Total Tests",
                        value: "\(tests.count)",
                        icon: "list.clipboard",
                        iconColor: .blue
                    )
                    
                    StatItemView(
                        title: "Depression",
                        value: String(format: "%.1f", averageScores.depression),
                        icon: "brain.head.profile",
                        iconColor: .purple
                    )
                    
                    StatItemView(
                        title: "Anxiety",
                        value: String(format: "%.1f", averageScores.anxiety),
                        icon: "heart.circle",
                        iconColor: .blue
                    )
                    
                    StatItemView(
                        title: "Stress",
                        value: String(format: "%.1f", averageScores.stress),
                        icon: "wind",
                        iconColor: .green
                    )
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // 下次测试建议卡片
            if let nextTest = suggestedNextTest {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Next Assessment")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 18))
                                .foregroundStyle(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Suggested Date")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(nextTest, style: .date)
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(.vertical, 8)
    }
}

// 测试行组件
struct DASS21TestRow: View {
    let test: DASS21Test
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // 抑郁指标
                ScoreIndicator(
                    score: test.depressionScore,
                    severity: test.depressionSeverity,
                    color: .purple,
                    label: "Depression"
                )
                
                Divider()
                    .frame(height: 24)
                
                // 焦虑指标
                ScoreIndicator(
                    score: test.anxietyScore,
                    severity: test.anxietySeverity,
                    color: .blue,
                    label: "Anxiety"
                )
                
                Divider()
                    .frame(height: 24)
                
                // 压力指标
                ScoreIndicator(
                    score: test.stressScore,
                    severity: test.stressSeverity,
                    color: .green,
                    label: "Stress"
                )
            }
            
            Text(test.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// 分数指标组件
private struct ScoreIndicator: View {
    let score: Int
    let severity: String
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(score)")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        DASS21HistoryView()
            .modelContainer(PreviewSampleData.shared.container)
    }
} 