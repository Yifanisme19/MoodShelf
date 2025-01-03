import SwiftUI
import SwiftData

struct AddShelfView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var emoji: String = "📝"
    @FocusState private var isNameFieldFocused: Bool
    
    // 预设的emoji选项
    private let defaultEmojis = ["📝", "💼", "🏠", "❤️", "🌟", "🎯", "📚", "✨", "🎨", "🎵", "🏃", "🍽️", "🌱", "🎮", "🎧", "📱", "💡", "🎬", "📷", "🎪"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Name Input Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Name")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter a particular event, activity, or state", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .focused($isNameFieldFocused)
                    }
                    .padding(.horizontal)
                    
                    // Emoji Selection Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose an emoji")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        // Selected Emoji Display
                        HStack(spacing: 12) {
                            Text(emoji)
                                .font(.system(size: 32))
                                .frame(width: 64, height: 64)
                                .background(
                                    Circle()
                                        .fill(Color.green.opacity(0.1))
                                        .overlay(
                                            Circle()
                                                .strokeBorder(Color.green, lineWidth: 2)
                                        )
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Selected Emoji")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("Choose an emoji that best represents this category")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        // Emoji Grid
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(defaultEmojis, id: \.self) { defaultEmoji in
                                EmojiButton(
                                    emoji: defaultEmoji,
                                    isSelected: emoji == defaultEmoji,
                                    action: { 
                                        withAnimation {
                                            emoji = defaultEmoji
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let shelf = Shelf(name: name, emoji: emoji)
                        modelContext.insert(shelf)
                        dismiss()
                    }
                    .disabled(name.isEmpty || emoji.isEmpty)
                }
            }
            .onAppear {
                isNameFieldFocused = true
            }
        }
    }
}

#Preview {
    AddShelfView()
        .modelContainer(PreviewSampleData.shared.container)
} 
