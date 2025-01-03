import SwiftUI

struct PHQRecommendationsCard: View {
    let test: PHQTest
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ForEach(recommendations, id: \.title) { recommendation in
                RecommendationRow(
                    recommendation: recommendation,
                    severityColor: test.severityColor(severity: test.severity)
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private var recommendations: [Recommendation] {
        switch test.totalScore {
        case 0...4:
            return [
                Recommendation(
                    title: "Maintain Healthy Habits",
                    description: "Continue with regular exercise, balanced diet, and good sleep patterns.",
                    icon: "heart.fill"
                ),
                Recommendation(
                    title: "Stay Connected",
                    description: "Keep nurturing your relationships with family and friends.",
                    icon: "person.2.fill"
                ),
                Recommendation(
                    title: "Practice Mindfulness",
                    description: "Consider incorporating meditation or mindfulness practices into your daily routine.",
                    icon: "leaf.fill"
                )
            ]
        case 5...9:
            return [
                Recommendation(
                    title: "Regular Mood Tracking",
                    description: "Use MoodShelf to track your emotions daily and identify patterns.",
                    icon: "chart.line.uptrend.xyaxis"
                ),
                Recommendation(
                    title: "Stress Management",
                    description: "Try relaxation techniques like deep breathing or gentle exercise.",
                    icon: "wind"
                ),
                Recommendation(
                    title: "Self-Care Activities",
                    description: "Make time for activities you enjoy and that help you relax.",
                    icon: "heart.circle.fill"
                )
            ]
        case 10...14:
            return [
                Recommendation(
                    title: "Seek Professional Help",
                    description: "Consider talking to a mental health professional for guidance.",
                    icon: "person.fill.questionmark"
                ),
                Recommendation(
                    title: "Support Groups",
                    description: "Join support groups or communities where you can share experiences.",
                    icon: "person.3.fill"
                ),
                Recommendation(
                    title: "Lifestyle Changes",
                    description: "Focus on improving sleep, exercise, and maintaining a routine.",
                    icon: "clock.fill"
                )
            ]
        default:
            return [
                Recommendation(
                    title: "Immediate Professional Help",
                    description: "Contact a mental health professional or counselor as soon as possible.",
                    icon: "cross.case.fill"
                ),
                Recommendation(
                    title: "Support System",
                    description: "Reach out to trusted friends or family members for support.",
                    icon: "hand.raised.fill"
                ),
                Recommendation(
                    title: "Crisis Resources",
                    description: "Save emergency helpline numbers and know your local mental health resources.",
                    icon: "phone.fill"
                )
            ]
        }
    }
}

// 建议数据模型
struct Recommendation {
    let title: String
    let description: String
    let icon: String
}

// 建议行视图组件
struct RecommendationRow: View {
    let recommendation: Recommendation
    let severityColor: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: recommendation.icon)
                .font(.title2)
                .foregroundStyle(severityColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recommendation.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(recommendation.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 8)
    }
} 