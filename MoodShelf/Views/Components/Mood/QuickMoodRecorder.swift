import SwiftUI

struct QuickMoodRecorder: View {
    let onMoodSelected: (MoodType) -> Void
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 12) {
            MoodButton(
                type: .positive,
                color: .green,
                isAnimating: isAnimating,
                action: { onMoodSelected(.positive) }
            )
            
            MoodButton(
                type: .negative,
                color: .gray.opacity(0.1),
                isAnimating: isAnimating,
                action: { onMoodSelected(.negative) }
            )
        }
        .onAppear { isAnimating = true }
    }
}

private struct MoodButton: View {
    let type: MoodType
    let color: Color
    let isAnimating: Bool
    let action: () -> Void
    
    @State private var scale: CGFloat = 1
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        Button(action: {
            // 触发触觉反馈
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            
            withAnimation(.spring(dampingFraction: 0.6)) {
                scale = 0.8
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    scale = 1
                    action()
                }
            }
        }) {
            Text(type == .positive ? "Positive" : "Negative")
                .font(.headline)
                .foregroundStyle(type == .positive ? .white : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(color.opacity(0.8))
                .cornerRadius(25)
        }
        .scaleEffect(scale)
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1 : 0)
        .animation(.spring(dampingFraction: 0.7).delay(type == .positive ? 0 : 0.1), value: isAnimating)
    }
} 
