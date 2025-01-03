import SwiftUI

struct AssessmentRecommendationRow: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(color)
                )
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
} 