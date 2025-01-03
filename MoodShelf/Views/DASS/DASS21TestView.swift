import SwiftUI
import SwiftData

struct DASS21TestView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentQuestion = 0
    @State private var answers = Array(repeating: -1, count: 21)
    @State private var showingResult = false
    @State private var selectedAnswer: Int? = nil
    @State private var isProcessingAnswer = false
    @State private var test: DASS21Test? = nil  // 用于存储创建的测试
    
    var progress: Double {
        Double(currentQuestion) / Double(DASS21Test.questions.count)
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
                    // 问题编号和类型
                    HStack {
                        Text("Question \(currentQuestion + 1) of \(DASS21Test.questions.count)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        // 显示当前问题属于哪个维度
                        Text(questionType)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(questionTypeColor.opacity(0.1))
                            .foregroundStyle(questionTypeColor)
                            .clipShape(Capsule())
                    }
                    
                    // 问题内容
                    Text(DASS21Test.questions[currentQuestion])
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
                                    Text(DASS21Test.optionDescriptions[score])
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
                
                if currentQuestion < DASS21Test.questions.count - 1 {
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
        .navigationTitle("DASS-21")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showingResult) {
            if let test = test {
                DASS21ResultView(
                    test: test,
                    onSave: { savedTest in
                        try? modelContext.save()
                        dismiss()
                    },
                    onRetake: {
                        retakeTest()
                    }
                )
            }
        }
    }
    
    private var questionType: String {
        if DASS21Test.depressionQuestions.contains(currentQuestion + 1) {
            return "Depression"
        } else if DASS21Test.anxietyQuestions.contains(currentQuestion + 1) {
            return "Anxiety"
        } else {
            return "Stress"
        }
    }
    
    private var questionTypeColor: Color {
        switch questionType {
        case "Depression": return .purple
        case "Anxiety": return .blue
        default: return .green
        }
    }
    
    private func selectAnswer(_ score: Int) {
        withAnimation {
            selectedAnswer = score
            isProcessingAnswer = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                answers[currentQuestion] = score
                selectedAnswer = nil
                isProcessingAnswer = false
                
                if currentQuestion < DASS21Test.questions.count - 1 {
                    currentQuestion += 1
                }
            }
        }
    }
    
    private func createTest() -> DASS21Test? {
        guard answers.allSatisfy({ $0 >= 0 }) else { return nil }
        let test = DASS21Test(answers: answers)
        modelContext.insert(test)
        return test
    }
    
    private func completeTest() {
        if let createdTest = createTest() {
            test = createdTest
            showingResult = true
        }
    }
    
    private func retakeTest() {
        answers = Array(repeating: -1, count: 21)
        currentQuestion = 0
        showingResult = false
    }
}

#Preview {
    NavigationStack {
        DASS21TestView()
            .modelContainer(PreviewSampleData.shared.container)
    }
} 
