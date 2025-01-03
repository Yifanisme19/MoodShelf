import SwiftUI
import SwiftData

struct PHQTestCard: View {
    @Query(sort: \PHQTest.date, order: .reverse) private var tests: [PHQTest]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 标题部分
            HStack(spacing: 12) {
                // 更精致的图标设计
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 44, height: 44)
                    Circle()
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        .frame(width: 44, height: 44)
                    Image(systemName: "heart.text.square")
                        .font(.title2)
                        .foregroundStyle(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Self-Assessment")
                        .font(.headline)
                    Text("PHQ-9 Questionnaire")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // 添加推荐标签
                if tests.isEmpty {
                    Text("Recommended")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            // 分隔线
            Divider()
                .padding(.horizontal, -16)
            
            // 最近测评结果
            if let latestTest = tests.first {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Recent")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(latestTest.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    // 更丰富的结果展示
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Text(latestTest.severity)
                                .font(.headline)
                            
                            Text("|")
                                .foregroundStyle(.secondary)
                            
                            Text("Score: \(latestTest.totalScore)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                        }
                        
                        // 添加趋势指示
                        if tests.count >= 2 {
                            let trend = getTrend(current: latestTest, previous: tests[1])
                            HStack(spacing: 4) {
                                Image(systemName: trend.icon)
                                    .font(.caption)
                                    .foregroundStyle(trend.color)
                                Text(trend.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.green.opacity(0.8))
                    Text("Complete the first assessment to understand your mental health status.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            HStack(spacing: 16) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.caption)
                    Text("Take Questionnaire")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundStyle(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.green.opacity(0.8))
                .cornerRadius(25)
                
                Spacer()
                
                // 查看历史按钮
                NavigationLink {
                    PHQHistoryView()
                } label: {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.caption)
                        Text("History")
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func getTrend(current: PHQTest, previous: PHQTest) -> (icon: String, color: Color, description: String) {
        let diff = current.totalScore - previous.totalScore
        if diff > 0 {
            return ("arrow.up.circle.fill", .red, "Increase of \(diff) points from last time")
        } else if diff < 0 {
            return ("arrow.down.circle.fill", .green, "\(abs(diff)) points lower than last time")
        } else {
            return ("equal.circle.fill", .blue, "Same as last time")
        }
    }
}

#Preview {
    PHQTestCard()
        .modelContainer(PreviewSampleData.shared.container)
} 