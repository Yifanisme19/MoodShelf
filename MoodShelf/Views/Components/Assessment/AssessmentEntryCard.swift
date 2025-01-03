import SwiftUI

struct AssessmentEntryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 标题部分
            HStack(spacing: 16) {
                // 图标设计
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 56, height: 56)
                    Circle()
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                        .frame(width: 56, height: 56)
                    Image(systemName: "brain.head.profile")
                        .font(.title2)
                        .foregroundStyle(.purple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mental Health Assessment")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Understand your mental well-being")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.purple.opacity(0.8))
            }
            
            // 分隔线
            Divider()
            
            // 功能描述
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(
                    icon: "list.bullet.clipboard",
                    color: .blue,
                    text: "Multiple assessment tools"
                )
                
                FeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green,
                    text: "Track your progress over time"
                )
                
                FeatureRow(
                    icon: "lightbulb",
                    color: .orange,
                    text: "Get personalized recommendations"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

// 功能行组件
private struct FeatureRow: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
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

#Preview {
    AssessmentEntryCard()
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
} 