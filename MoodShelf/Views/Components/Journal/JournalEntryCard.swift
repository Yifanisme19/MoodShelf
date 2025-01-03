import SwiftUI

struct JournalEntryCard: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            // 顶部图标
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.green)
            }
            
            // 文字部分
            VStack(spacing: 8) {
                Text("Write Journal")
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                
                Text("Record your thoughts and feelings")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 10,
                    x: 0,
                    y: 4
                )
        )
        .contentShape(RoundedRectangle(cornerRadius: 16))
        // 添加点击效果
        .buttonStyle(ScaleButtonStyle())
    }
}

// 自定义按钮样式，添加缩放动画
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

#Preview {
    VStack {
        JournalEntryCard()
            .padding()
        
        JournalEntryCard()
            .padding()
            .preferredColorScheme(.dark)
    }
    .background(Color(.systemGroupedBackground))
} 
