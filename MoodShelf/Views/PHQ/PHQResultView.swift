import SwiftUI

struct PHQResultView: View {
    let test: PHQTest
    let onSave: (PHQTest) -> Void
    let onRetake: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 结果卡片
                VStack(spacing: 16) {
                    Text("Result")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text("\(test.severity)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(test.severityColor(severity: test.severity))
                        .multilineTextAlignment(.center)
                    
                    Text("Score: \(test.totalScore)")
                        .font(.title2)
                    
                    // 分数解释
                    Text(severityExplanation)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // 使用新的建议卡片组件
                PHQRecommendationsCard(test: test)
                
                // 操作按钮
                VStack(spacing: 16) {
                    Button {
                        onSave(test)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(25)
                    }
                    
                    Button("Try again", action: onRetake)
                        .foregroundStyle(.gray)
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Assessment Completed")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
    
    private var severityExplanation: String {
        switch test.totalScore {
        case 0...4:
            return "Your mental state is good, please continue to maintain a positive and optimistic attitude towards life."
        case 5...9:
            return "You may have mild symptoms of depression, it is recommended to pay attention to your mood changes."
        case 10...14:
            return "You may have moderate depressive symptoms and it is recommended to seek professional psychological counseling."
        case 15...19:
            return "You may have severe symptoms of depression, and prompt medical attention is strongly recommended."
        default:
            return "You may have severe symptoms of depression. Seek medical help immediately."
        }
    }
}

#Preview("无抑郁") {
    NavigationStack {
        PHQResultView(
            test: PHQTest(answers: [0, 0, 1, 0, 0, 0, 0, 0, 0]), // 总分1 - 无抑郁
            onSave: { _ in },
            onRetake: { }
        )
    }
}

#Preview("轻度抑郁") {
    NavigationStack {
        PHQResultView(
            test: PHQTest(answers: [1, 1, 1, 1, 1, 1, 1, 0, 0]), // 总分7 - 轻度抑郁
            onSave: { _ in },
            onRetake: { }
        )
    }
}

#Preview("中度抑郁") {
    NavigationStack {
        PHQResultView(
            test: PHQTest(answers: [2, 2, 1, 1, 1, 1, 1, 1, 2]), // 总分12 - 中度抑郁
            onSave: { _ in },
            onRetake: { }
        )
    }
}

#Preview("重度抑郁") {
    NavigationStack {
        PHQResultView(
            test: PHQTest(answers: [3, 3, 3, 3, 3, 3, 3, 3, 3]), // 总分27 - 重度抑郁
            onSave: { _ in },
            onRetake: { }
        )
    }
} 
