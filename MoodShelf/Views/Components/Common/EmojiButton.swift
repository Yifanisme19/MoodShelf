import SwiftUI

struct EmojiButton: View {
    let emoji: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(emoji)
                .font(.system(size: 28))
                .frame(width: 56, height: 56)
                .background(
                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                            Circle()
                                .strokeBorder(Color.green, lineWidth: 2)
                        } else {
                            Circle()
                                .fill(Color(.systemBackground))
                            Circle()
                                .strokeBorder(Color(.systemGray5), lineWidth: 1)
                        }
                    }
                )
                .shadow(color: isSelected ? .green.opacity(0.2) : .clear, radius: 8)
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
} 
