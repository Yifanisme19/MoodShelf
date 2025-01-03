import SwiftUI
import SwiftData

struct DASS21ResultView: View {
    let test: DASS21Test
    let onSave: (DASS21Test) -> Void
    let onRetake: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 总览卡片
                VStack(spacing: 16) {
                    Text("Assessment Results")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text(test.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // 抑郁分数卡片
                ScoreCard(
                    title: "Depression",
                    score: test.depressionScore,
                    severity: test.depressionSeverity,
                    color: .purple
                )
                
                // 焦虑分数卡片
                ScoreCard(
                    title: "Anxiety",
                    score: test.anxietyScore,
                    severity: test.anxietySeverity,
                    color: .blue
                )
                
                // 压力分数卡片
                ScoreCard(
                    title: "Stress",
                    score: test.stressScore,
                    severity: test.stressSeverity,
                    color: .green
                )
                
                // 建议卡片
                RecommendationsCard(test: test)
                
                // 操作按钮
                VStack(spacing: 16) {
                    Button {
                        onSave(test)
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(25)
                    }
                    
                    Button("Try again", action: onRetake)
                        .foregroundStyle(.gray)
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("DASS-21 Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 分数卡片组件
private struct ScoreCard: View {
    let title: String
    let score: Int
    let severity: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 12) {
                Text(severity)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
                
                Spacer()
                
                // 严重程度指示器
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.2))
                        .frame(width: 100, height: 8)
                    
                    Capsule()
                        .fill(color)
                        .frame(width: getSeverityWidth(severity), height: 8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func getSeverityWidth(_ severity: String) -> CGFloat {
        switch severity {
        case "Normal": return 20
        case "Mild": return 40
        case "Moderate": return 60
        case "Severe": return 80
        default: return 100
        }
    }
}

// 建议卡片组件
private struct RecommendationsCard: View {
    let test: DASS21Test
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                if test.depressionScore > 9 {
                    AssessmentRecommendationRow(
                        icon: "brain.head.profile",
                        color: .purple,
                        text: "Consider consulting a mental health professional about your depression symptoms"
                    )
                }
                
                if test.anxietyScore > 7 {
                    AssessmentRecommendationRow(
                        icon: "heart.circle",
                        color: .blue,
                        text: "Practice relaxation techniques to manage anxiety"
                    )
                }
                
                if test.stressScore > 14 {
                    AssessmentRecommendationRow(
                        icon: "leaf",
                        color: .green,
                        text: "Incorporate stress management activities into your daily routine"
                    )
                }
                
                AssessmentRecommendationRow(
                    icon: "person.2",
                    color: .orange,
                    text: "Maintain regular contact with supportive friends and family"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        DASS21ResultView(test: PreviewSampleData.shared.sampleDASS21Test, onSave: { _ in }, onRetake: {})
    }
} 