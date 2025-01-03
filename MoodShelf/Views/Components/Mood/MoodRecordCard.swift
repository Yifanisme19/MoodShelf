import SwiftUI

struct MoodRecordCard: View {
    let onMoodSelected: (MoodType) -> Void
    @State private var selectedMood: MoodType?
    @State private var isAnimating = false
    @State private var isButtonsEnabled = false
    
    var body: some View {
        VStack(spacing: 24) {
            // 标题区域
            VStack(spacing: 8) {
                Text("How are you feeling right now?")
                    .font(.title3.weight(.medium))
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .blur(radius: isAnimating ? 0 : 10)
                
                Text("Take a moment to reflect")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .blur(radius: isAnimating ? 0 : 10)
            }
            .padding(.top, 8)
            
            // 心情选择区域
            HStack(spacing: 24) {
                MoodOptionButton(
                    mood: .positive,
                    isSelected: selectedMood == .positive,
                    isDisabled: selectedMood != nil && selectedMood != .positive,
                    action: { selectMood(.positive) }
                )
                .opacity(isAnimating ? 1 : 0)
                .offset(x: isAnimating ? 0 : -50)
                .blur(radius: isAnimating ? 0 : 5)
                .rotationEffect(isAnimating ? .degrees(0) : .degrees(-10))
                
                MoodOptionButton(
                    mood: .negative,
                    isSelected: selectedMood == .negative,
                    isDisabled: selectedMood != nil && selectedMood != .negative,
                    action: { selectMood(.negative) }
                )
                .opacity(isAnimating ? 1 : 0)
                .offset(x: isAnimating ? 0 : 50)
                .blur(radius: isAnimating ? 0 : 5)
                .rotationEffect(isAnimating ? .degrees(0) : .degrees(10))
            }
            .padding(.horizontal, 20)
            .disabled(!isButtonsEnabled)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 20,
                    x: 0,
                    y: 10
                )
        }
        .onAppear {
            // 标题动画
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
            }
            
            // 延迟启用按钮，让用户先看到界面
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isButtonsEnabled = true
            }
        }
    }
    
    private func selectMood(_ mood: MoodType) {
        // 先触发触觉反馈
        hapticFeedback()
        
        // 选中动画
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedMood = mood
        }
        
        // 重置状态并触发回调
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                selectedMood = nil
            }
            onMoodSelected(mood)
        }
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
}

private struct MoodOptionButton: View {
    let mood: MoodType
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme
    
    private var config: MoodConfig {
        switch mood {
        case .positive:
            return MoodConfig(
                emoji: "😊",
                title: "Good",
                subtitle: "Feeling positive",
                gradient: [Color.green, Color.teal],
                scale: isSelected ? 1.05 : (isDisabled ? 0.95 : (isHovered ? 1.02 : 1.0))
            )
        case .negative:
            return MoodConfig(
                emoji: "😔",
                title: "Bad",
                subtitle: "Not so great",
                gradient: [Color.indigo, Color.purple],
                scale: isSelected ? 1.05 : (isDisabled ? 0.95 : (isHovered ? 1.02 : 1.0))
            )
        }
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            VStack(spacing: 12) {
                // Emoji 展示区
                Text(config.emoji)
                    .font(.system(size: 38))
                    .symbolEffect(.bounce.up.byLayer, value: isSelected)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                
                // 文字描述区
                VStack(spacing: 4) {
                    Text(config.title)
                        .font(.headline)
                        .foregroundStyle(isDisabled ? .secondary : .primary)
                    
                    Text(config.subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.secondary.opacity(isDisabled ? 0.7 : 1))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .shadow(
                        color: config.gradient[0].opacity(isDisabled ? 0.1 : (isHovered ? 0.3 : 0.2)),
                        radius: isSelected ? 15 : (isHovered ? 12 : 10),
                        x: 0,
                        y: isSelected ? 8 : (isHovered ? 6 : 5)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: isSelected ? config.gradient : (isHovered ? [config.gradient[0].opacity(0.3)] : [.clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 2 : (isHovered ? 1 : 0)
                            )
                    }
            }
            .scaleEffect(config.scale)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .onHover { hovering in
            withAnimation(.spring(response: 0.3)) {
                isHovered = hovering && !isDisabled
            }
        }
    }
}

private struct MoodConfig {
    let emoji: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    let scale: CGFloat
}

#Preview {
    VStack(spacing: 20) {
        MoodRecordCard { _ in }
            .padding()
        
        MoodRecordCard { _ in }
            .padding()
            .preferredColorScheme(.dark)
    }
    .background(Color(.systemGroupedBackground))
} 
