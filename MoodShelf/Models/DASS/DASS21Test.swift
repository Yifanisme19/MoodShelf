import Foundation
import SwiftData
import SwiftUI

@Model
class DASS21Test: Identifiable {
    var id: UUID
    var date: Date
    var answers: [Int]  // 21个问题的答案
    
    // 计算得分（已乘2）
    var depressionScore: Int
    var anxietyScore: Int
    var stressScore: Int
    
    // 严重程度评估
    var depressionSeverity: String
    var anxietySeverity: String
    var stressSeverity: String
    
    init(answers: [Int]) {
        self.id = UUID()
        self.date = Date()
        self.answers = answers
        
        // 先计算分数
        let depression = DASS21Test.calculateDepressionScore(answers: answers)
        let anxiety = DASS21Test.calculateAnxietyScore(answers: answers)
        let stress = DASS21Test.calculateStressScore(answers: answers)
        
        // 设置分数
        self.depressionScore = depression
        self.anxietyScore = anxiety
        self.stressScore = stress
        
        // 评估严重程度
        self.depressionSeverity = DASS21Test.assessDepressionSeverity(score: depression)
        self.anxietySeverity = DASS21Test.assessAnxietySeverity(score: anxiety)
        self.stressSeverity = DASS21Test.assessStressSeverity(score: stress)
    }
    
    // MARK: - Score Calculations
    private static func calculateDepressionScore(answers: [Int]) -> Int {
        let depressionQuestions = [3, 5, 10, 13, 16, 17, 21]
        let sum = depressionQuestions.reduce(0) { $0 + answers[$1 - 1] }
        return sum * 2
    }
    
    private static func calculateAnxietyScore(answers: [Int]) -> Int {
        let anxietyQuestions = [2, 4, 7, 9, 15, 19, 20]
        let sum = anxietyQuestions.reduce(0) { $0 + answers[$1 - 1] }
        return sum * 2
    }
    
    private static func calculateStressScore(answers: [Int]) -> Int {
        let stressQuestions = [1, 6, 8, 11, 12, 14, 18]
        let sum = stressQuestions.reduce(0) { $0 + answers[$1 - 1] }
        return sum * 2
    }
    
    // MARK: - Severity Assessment
    private static func assessDepressionSeverity(score: Int) -> String {
        switch score {
        case 0...9: return "Normal"
        case 10...13: return "Mild"
        case 14...20: return "Moderate"
        case 21...27: return "Severe"
        default: return "Extremely Severe"
        }
    }
    
    private static func assessAnxietySeverity(score: Int) -> String {
        switch score {
        case 0...7: return "Normal"
        case 8...9: return "Mild"
        case 10...14: return "Moderate"
        case 15...19: return "Severe"
        default: return "Extremely Severe"
        }
    }
    
    private static func assessStressSeverity(score: Int) -> String {
        switch score {
        case 0...14: return "Normal"
        case 15...18: return "Mild"
        case 19...25: return "Moderate"
        case 26...33: return "Severe"
        default: return "Extremely Severe"
        }
    }
    
    // MARK: - Helper Methods
    func severityColor(for severity: String) -> Color {
        switch severity {
        case "Normal": return .green
        case "Mild": return .yellow
        case "Moderate": return .orange
        case "Severe": return .red
        default: return .purple
        }
    }
}

// MARK: - Question Data
extension DASS21Test {
    static let questions = [
        "I found it hard to wind down",  // S
        "I was aware of dryness of my mouth",  // A
        "I couldn't seem to experience any positive feeling at all",  // D
        "I experienced breathing difficulty",  // A
        "I found it difficult to work up the initiative to do things",  // D
        "I tended to over-react to situations",  // S
        "I experienced trembling (e.g., in the hands)",  // A
        "I felt that I was using a lot of nervous energy",  // S
        "I was worried about situations in which I might panic",  // A
        "I felt that I had nothing to look forward to",  // D
        "I found myself getting agitated",  // S
        "I found it difficult to relax",  // S
        "I felt down-hearted and blue",  // D
        "I was intolerant of anything that kept me from getting on",  // S
        "I felt I was close to panic",  // A
        "I was unable to become enthusiastic about anything",  // D
        "I felt I wasn't worth much as a person",  // D
        "I felt that I was rather touchy",  // S
        "I felt changes in my heart rate without physical exertion",  // A
        "I felt scared without any good reason",  // A
        "I felt that life was meaningless"  // D
    ]
    
    static let optionDescriptions = [
        "Did not apply to me at all",
        "Applied to me to some degree",
        "Applied to me to a considerable degree",
        "Applied to me very much"
    ]
    
    static let depressionQuestions = [3, 5, 10, 13, 16, 17, 21]
    static let anxietyQuestions = [2, 4, 7, 9, 15, 19, 20]
    static let stressQuestions = [1, 6, 8, 11, 12, 14, 18]
} 
