import SwiftUI

struct AssessmentRecommendationsCard: View {
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