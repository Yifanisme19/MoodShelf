import SwiftUI
import SwiftData

struct PHQTestView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentQuestion = 0
    @State private var answers = Array(repeating: -1, count: 9)
    @State private var showingResult = false
    @State private var selectedAnswer: Int? = nil
    @State private var isProcessingAnswer = false
    
    var progress: Double {
        Double(currentQuestion) / Double(PHQQuestions.questions.count)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // 进度条
            ProgressView(value: progress)
                .tint(.green)
                .padding(.horizontal)
            
            // 问题区域
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 问题编号
                    Text("Question \(currentQuestion + 1) of \(PHQQuestions.questions.count)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    // 问题内容
                    Text(PHQQuestions.questions[currentQuestion])
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    // 选项按钮
                    VStack(spacing: 16) {
                        ForEach(0..<4) { score in
                            Button {
                                if !isProcessingAnswer {
                                    selectAnswer(score)
                                }
                            } label: {
                                HStack {
                                    Text(PHQQuestions.options[score])
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    if answers[currentQuestion] == score || selectedAnswer == score {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                    } else {
                                        Circle()
                                            .strokeBorder(Color(.systemGray3), lineWidth: 1)
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill((answers[currentQuestion] == score || selectedAnswer == score) ? 
                                             Color.green.opacity(0.1) : Color(.systemBackground))
                                )
                            }
                            .buttonStyle(.plain)
                            .disabled(isProcessingAnswer)
                        }
                    }
                }
                .padding()
            }
            
            // 导航按钮
            HStack {
                if currentQuestion > 0 {
                    Button("Previous") {
                        withAnimation {
                            currentQuestion -= 1
                        }
                    }
                }
                
                Spacer()
                
                if currentQuestion < PHQQuestions.questions.count - 1 {
                    Button("Next") {
                        withAnimation {
                            currentQuestion += 1
                        }
                    }
                    .disabled(answers[currentQuestion] == -1)
                } else {
                    Button("Complete") {
                        completeTest()
                    }
                    .disabled(answers[currentQuestion] == -1 || !answers.allSatisfy { $0 >= 0 })
                }
            }
            .padding()
        }
        .navigationTitle("PHQ-9")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showingResult) {
            PHQResultView(
                test: PHQTest(answers: answers),
                onSave: saveTest,
                onRetake: retakeTest
            )
        }
    }
    
    private func selectAnswer(_ score: Int) {
        withAnimation {
            selectedAnswer = score
            isProcessingAnswer = true
        }
        
        // 延迟 0.5 秒后保存答案并自动进入下一题
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                answers[currentQuestion] = score
                selectedAnswer = nil
                isProcessingAnswer = false
                
                // 如果不是最后一题，自动进入下一题
                if currentQuestion < PHQQuestions.questions.count - 1 {
                    currentQuestion += 1
                }
            }
        }
    }
    
    private func saveTest(_ test: PHQTest) {
        withAnimation {
            modelContext.insert(test)
            try? modelContext.save()
            dismiss()
        }
    }
    
    private func retakeTest() {
        answers = Array(repeating: -1, count: 9)
        currentQuestion = 0
        showingResult = false
    }
    
    private func completeTest() {
        showingResult = true
    }
}

// 简化预览
#Preview {
    NavigationStack {
        PHQTestView()
            .modelContainer(PreviewSampleData.shared.container)
    }
} 
