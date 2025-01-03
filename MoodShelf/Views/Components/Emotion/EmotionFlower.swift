import SwiftUI

struct EmotionFlower: View {
    let selectedEmotion: Emotion?
    
    var body: some View {
        ZStack {
            // 玻璃态背景
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 200, height: 200)
            
            // 花瓣动画
            OverlappingCirclesFlowerView(
                color: selectedEmotion?.color ?? .gray.opacity(0.3)
            )
            .frame(width: 200, height: 200)
            .padding(20)
        }
    }
}

struct OverlappingCirclesFlowerView: View {
    let color: Color
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<8) { index in
                    Circle()
                        .fill(color.opacity(0.7))
                        .frame(width: min(geometry.size.width, geometry.size.height) / 2)
                        .offset(x: min(geometry.size.width, geometry.size.height) / 4)
                        .rotationEffect(.degrees(Double(index) * 45))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: scale)
            .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: rotation)
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    scale = 1.2
                    rotation = 22.5
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    EmotionFlower(selectedEmotion: .happiness)
} 