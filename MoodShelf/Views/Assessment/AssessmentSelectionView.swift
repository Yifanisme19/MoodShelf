import SwiftUI
import SwiftData

struct AssessmentSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PHQTest.date, order: .reverse) private var phqTests: [PHQTest]
    @Query(sort: \DASS21Test.date, order: .reverse) private var dassTests: [DASS21Test]
    
    @State private var showingPHQTest = false
    @State private var showingDASSTest = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // PHQ-9 卡片
                Button {
                    showingPHQTest = true
                } label: {
                    AssessmentCard(
                        title: "PHQ-9 Depression Assessment",
                        description: "The PHQ-9 is a multipurpose instrument for screening, diagnosing, monitoring and measuring the severity of depression.",
                        icon: "brain.head.profile",
                        iconColor: .purple,
                        duration: "5-10 minutes",
                        lastTest: phqTests.first?.date,
                        totalTests: phqTests.count
                    )
                }
                .sheet(isPresented: $showingPHQTest) {
                    NavigationStack {
                        PHQTestView()
                    }
                }
                
                // DASS-21 卡片
                Button {
                    showingDASSTest = true
                } label: {
                    AssessmentCard(
                        title: "DASS-21 Assessment",
                        description: "The DASS-21 measures the three related states of depression, anxiety and stress using a comprehensive set of questions.",
                        icon: "chart.bar.doc.horizontal",
                        iconColor: .blue,
                        duration: "8-12 minutes",
                        lastTest: dassTests.first?.date,
                        totalTests: dassTests.count
                    )
                }
                .sheet(isPresented: $showingDASSTest) {
                    NavigationStack {
                        DASS21TestView()
                    }
                }
                
                // GAD-7 焦虑量表（目前禁用）
                AssessmentCard(
                    title: "GAD-7 Anxiety Assessment",
                    description: "The GAD-7 is a screening tool and severity measure for Generalized Anxiety Disorder.",
                    icon: "heart.circle",
                    iconColor: .indigo,
                    duration: "3-5 minutes",
                    isComingSoon: true
                )
            }
            .padding()
        }
        .navigationTitle("Assessments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 更新问卷卡片组件
struct AssessmentCard: View {
    let title: String
    let description: String
    let icon: String
    let iconColor: Color
    let duration: String
    var lastTest: Date? = nil
    var totalTests: Int = 0
    var isComingSoon: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 图标和标题
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(iconColor)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(iconColor.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    
                    Text(duration)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if isComingSoon {
                    Text("Coming Soon")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.gray.opacity(0.1))
                        )
                        .foregroundStyle(.secondary)
                } else if totalTests == 0 {
                    Text("Recommended")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let test = lastTest {
                Divider()
                
                // 最近的测试结果
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Recent Test Date")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(test.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            if !isComingSoon {
                HStack {
                    // 总测试次数
                    if totalTests > 0 {
                        Text("\(totalTests) tests taken")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    // 历史记录按钮
                    if totalTests > 0 {
                        NavigationLink {
                            if title.contains("PHQ-9") {
                                PHQHistoryView()
                            } else if title.contains("DASS-21") {
                                DASS21HistoryView()
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("History")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isComingSoon ? Color.gray.opacity(0.1) : iconColor.opacity(0.1), lineWidth: 1)
        )
        .opacity(isComingSoon ? 0.6 : 1)
        .disabled(isComingSoon)
    }
}

#Preview {
    NavigationStack {
        AssessmentSelectionView()
            .modelContainer(PreviewSampleData.shared.container)
    }
} 
