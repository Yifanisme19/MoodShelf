import SwiftUI

struct EmotionPicker: View {
    @Binding var selectedEmotion: Emotion?
    let emotions = Emotion.allCases
    
    var body: some View {
        VStack(spacing: 30) {
            // 花朵动画
            EmotionFlower(selectedEmotion: selectedEmotion)
                .frame(height: 250)
            
            // 情绪选择网格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                ForEach(emotions, id: \.self) { emotion in
                    EmotionButton(
                        emotion: emotion,
                        isSelected: selectedEmotion == emotion,
                        action: { selectedEmotion = emotion }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)
        )
    }
}

struct EmotionButton: View {
    let emotion: Emotion
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(emotion.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(emotion.color, lineWidth: isSelected ? 3 : 0)
                            .padding(-3)
                    )
                    .shadow(color: emotion.color.opacity(0.5), radius: isSelected ? 8 : 0)
                
                Text(emotion.rawValue)
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    EmotionPicker(selectedEmotion: .constant(.happiness))
        .padding()
} 
