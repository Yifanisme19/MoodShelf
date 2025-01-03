import SwiftUI
import SwiftData
import PDFKit
import UIKit

struct PHQHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PHQTest.date, order: .reverse) private var tests: [PHQTest]
    
    // 计算最近趋势
    private var recentTrend: Double? {
        guard tests.count >= 2 else { return nil }
        let latest = tests[0].totalScore
        let previous = tests[1].totalScore
        return Double(latest - previous)
    }
    
    // 计算平均分数
    private var averageScore: Double {
        guard !tests.isEmpty else { return 0 }
        let sum = tests.reduce(0) { $0 + $1.totalScore }
        return Double(sum) / Double(tests.count)
    }
    
    // 计算严重程度分布
    private var severityDistribution: [(String, Int)] {
        var distribution: [String: Int] = [:]
        tests.forEach { test in
            distribution[test.severity, default: 0] += 1
        }
        return distribution.sorted { $0.1 > $1.1 }
    }
    
    // 计算建议的下次测试时间
    private var suggestedNextTest: Date? {
        guard let lastTest = tests.first?.date else { return nil }
        // 建议每两周进行一次测试
        return Calendar.current.date(byAdding: .day, value: 14, to: lastTest)
    }
    
    var body: some View {
        List {
            if !tests.isEmpty {
                Section {
                    AnalysisCardView(
                        testsCount: tests.count,
                        averageScore: averageScore,
                        recentTrend: recentTrend,
                        suggestedNextTest: suggestedNextTest,
                        severityDistribution: severityDistribution
                    )
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
                        systemImage: "heart.text.clipboard",
                        description: Text("After completing a PHQ-9 questionnaire, the record will be displayed here")
                    )
                } else {
                    ForEach(tests) { test in
                        NavigationLink {
                            PHQTestDetailView(test: test)
                        } label: {
                            PHQTestRow(test: test)
                        }
                    }
                    .onDelete(perform: deletePHQTests)
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
    
    private func deletePHQTests(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tests[index])
            }
        }
    }
}

// 分析卡片视图
struct AnalysisCardView: View {
    let testsCount: Int
    let averageScore: Double
    let recentTrend: Double?
    let suggestedNextTest: Date?
    let severityDistribution: [(String, Int)]
    
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
                        value: "\(testsCount)",
                        icon: "list.clipboard",
                        iconColor: .blue
                    )
                    
                    StatItemView(
                        title: "Average",
                        value: String(format: "%.1f", averageScore),
                        icon: "chart.bar",
                        iconColor: .purple
                    )
                    
                    if let trend = recentTrend {
                        StatItemView(
                            title: "Recent",
                            value: trend > 0 ? "+\(Int(trend))" : "\(Int(trend))",
                            icon: trend > 0 ? "arrow.up.right" : "arrow.down.right",
                            iconColor: trend > 0 ? .red : .green,
                            valueColor: trend > 0 ? .red : .green
                        )
                    }
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

// 更新统计项视图
struct StatItemView: View {
    let title: String
    let value: String
    let icon: String
    var iconColor: Color = .blue
    var valueColor: Color = .primary
    
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
                    .foregroundStyle(valueColor)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// PHQ测试行视图
struct PHQTestRow: View {
    let test: PHQTest
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(test.severityColor(severity: test.severity))
                
                Text(test.severity)
                    .font(.subheadline)
                
                Spacer()
                
                Text("Score: \(test.totalScore)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(test.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct PHQTestDetailView: View {
    let test: PHQTest
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 结果卡片
                VStack(spacing: 16) {
                    Text("Result")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text("\(test.severity)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(test.severityColor(severity: test.severity))
                    
                    Text("Score: \(test.totalScore)")
                        .font(.title2)
                    
                    // 分数解释
                    Text(severityExplanation)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // 添加建议卡片
                PHQRecommendationsCard(test: test)
                
                // 答案列表
                VStack(alignment: .leading, spacing: 16) {
                    Text("Answers")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    // 添加答案图例
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Score Legend")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        VStack(spacing: 16) {
                            ForEach(0..<4) { score in
                                HStack(spacing: 6) {
                                    Text("\(score)")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                        .frame(width: 20, height: 20)
                                        .background(
                                            Circle()
                                                .stroke(Color(.systemGray3), lineWidth: 1)
                                        )
                                    
                                    Text(scoreText(score))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    
                    ForEach(Array(test.answers.enumerated()), id: \.offset) { index, answer in
                        VStack(alignment: .leading, spacing: 8) {
                            // 问题
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(index + 1).")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text(PHQQuestions.questions[index])
                                    .font(.subheadline)
                                
                                Spacer()
                            }
                            .padding(.bottom, 8)
                            
                            // 简化的答案选项
                            HStack(spacing: 16) {
                                ForEach(0..<4) { score in
                                    Circle()
                                        .fill(answer == score ? .green : Color(.systemGray5))
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Text("\(score)")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundStyle(answer == score ? .white : .secondary)
                                        )
                                }
                            }
                            .padding(.leading, 24)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5)
            }
            .padding()
        }
        .navigationTitle(test.date.formatted(date: .abbreviated, time: .shortened))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var severityExplanation: String {
        switch test.totalScore {
        case 0...4:
            return "Your mental state is good, please continue to maintain a positive and optimistic attitude towards life."
        case 5...9:
            return "You may have mild symptoms of depression, it is recommended to pay attention to your mood changes."
        case 10...14:
            return "You may have moderate depressive symptoms and it is recommended to seek professional psychological counseling."
        case 15...19:
            return "You may have severe symptoms of depression, and prompt medical attention is strongly recommended."
        default:
            return "You may have severe symptoms of depression. Seek medical help immediately."
        }
    }
    
    // 辅助函数
    private func scoreText(_ score: Int) -> String {
        switch score {
        case 0: return "Not at all"
        case 1: return "Several days"
        case 2: return "More than half the days"
        case 3: return "Nearly every day"
        default: return ""
        }
    }
}

#Preview {
    NavigationStack {
        PHQHistoryView()
            .modelContainer(PreviewSampleData.shared.container)
    }
}

#Preview("Result") {
    NavigationStack {
        PHQTestDetailView(test: PreviewSampleData.shared.samplePHQTest1)
    }
} 
