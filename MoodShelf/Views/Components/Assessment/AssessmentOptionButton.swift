import SwiftUI

struct AssessmentOptionButton: View {
    let score: Int
    let isSelected: Bool
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("\(score)")
                    .font(.headline)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isSelected ? .blue : Color(.systemGray5))
                    )
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
} 