import SwiftUI
import SwiftData

struct DASS21TestDetailView: View {
    let test: DASS21Test
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 结果卡片
                VStack(spacing: 16) {
                    Text("Result")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text(test.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // 三个维度的分数
                    HStack(spacing: 20) {
                        ScoreCard(
                            title: "Depression",
                            score: test.depressionScore,
                            severity: test.depressionSeverity,
                            color: .purple
                        )
                        
                        ScoreCard(
                            title: "Anxiety",
                            score: test.anxietyScore,
                            severity: test.anxietySeverity,
                            color: .blue
                        )
                        
                        ScoreCard(
                            title: "Stress",
                            score: test.stressScore,
                            severity: test.stressSeverity,
                            color: .green
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // 建议卡片
                AssessmentRecommendationsCard(test: test)
                
                // 答案列表
                VStack(alignment: .leading, spacing: 16) {
                    Text("Answers")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    ForEach(Array(test.answers.enumerated()), id: \.offset) { index, answer in
                        AnswerRow(
                            questionIndex: index,
                            question: DASS21Test.questions[index],
                            answer: answer,
                            type: getQuestionType(index: index + 1)
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5)
            }
            .padding()
        }
        .navigationTitle("Test Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func getQuestionType(index: Int) -> (String, Color) {
        if DASS21Test.depressionQuestions.contains(index) {
            return ("Depression", .purple)
        } else if DASS21Test.anxietyQuestions.contains(index) {
            return ("Anxiety", .blue)
        } else {
            return ("Stress", .green)
        }
    }
}

// 分数卡片组件
private struct ScoreCard: View {
    let title: String
    let score: Int
    let severity: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            VStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("\(score)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            }
            
            Text(severity)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color.opacity(0.1))
                .foregroundStyle(color)
                .clipShape(Capsule())
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 120)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// 答案行组件
private struct AnswerRow: View {
    let questionIndex: Int
    let question: String
    let answer: Int
    let type: (String, Color)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Question \(questionIndex + 1)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                Text(type.0)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(type.1.opacity(0.1))
                    .foregroundStyle(type.1)
                    .clipShape(Capsule())
                
                Spacer()
            }
            
            Text(question)
                .font(.subheadline)
            
            Text(DASS21Test.optionDescriptions[answer])
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 6)
                .background(Color(.systemBackground))
                .cornerRadius(8)

        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        DASS21TestDetailView(test: PreviewSampleData.shared.sampleDASS21Test)
    }
} 
