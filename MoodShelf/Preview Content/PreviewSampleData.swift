//
//  PreviewSampleData.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import Foundation
import SwiftData

@MainActor
class PreviewSampleData {
    static let shared = PreviewSampleData()
    
    let container: ModelContainer
    let context: ModelContext
    
    let sampleShelf1: Shelf
    let sampleShelf2: Shelf
    
    // 添加PHQ测试示例数据
    let samplePHQTest1: PHQTest
    let samplePHQTest2: PHQTest
    let samplePHQTest3: PHQTest
    
    // 添加DASS21测试示例数据
    let sampleDASS21Test1: DASS21Test
    let sampleDASS21Test2: DASS21Test
    
    private init() {
        do {
            // 为预览创建一个内存配置
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            
            // 创建Schema描述
            let schema = Schema([
                Shelf.self,
                Journal.self,
                MoodRecord.self,
                PHQTest.self,
                DASS21Test.self  // 添加DASS21Test到Schema
            ])
            
            // 初始化容器
            container = try ModelContainer(for: schema, configurations: config)
            context = ModelContext(container)
            
            // 创建示例数据
            sampleShelf1 = Shelf(name: "工作", emoji: "💼")
            sampleShelf2 = Shelf(name: "生活", emoji: "🏠")
            
            // 创建PHQ测试示例数据
            let testAnswers1 = [2, 1, 1, 2, 0, 1, 1, 0, 0]  // 总分8分 - 轻度抑郁
            samplePHQTest1 = PHQTest(answers: testAnswers1)
            samplePHQTest1.date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            
            let testAnswers2 = [3, 3, 2, 2, 1, 2, 2, 1, 0]  // 总分16分 - 中重度抑郁
            samplePHQTest2 = PHQTest(answers: testAnswers2)
            samplePHQTest2.date = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
            
            let testAnswers3 = [1, 0, 1, 1, 0, 0, 0, 0, 0]  // 总分3分 - 无或极轻度抑郁
            samplePHQTest3 = PHQTest(answers: testAnswers3)
            samplePHQTest3.date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            
            // 创建DASS21测试示例数据
            let dassAnswers1 = Array(repeating: 2, count: 21)  // 中度水平的答案
            sampleDASS21Test1 = DASS21Test(answers: dassAnswers1)
            sampleDASS21Test1.date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
            
            let dassAnswers2 = Array(repeating: 1, count: 21)  // 轻度水平的答案
            sampleDASS21Test2 = DASS21Test(answers: dassAnswers2)
            sampleDASS21Test2.date = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
            
            // 先保存 Shelf
            context.insert(sampleShelf1)
            context.insert(sampleShelf2)
            try context.save()
            
            // 保存PHQ测试数据
            context.insert(samplePHQTest1)
            context.insert(samplePHQTest2)
            context.insert(samplePHQTest3)
            try context.save()
            
            // 保存DASS21测试数据
            context.insert(sampleDASS21Test1)
            context.insert(sampleDASS21Test2)
            try context.save()
            
            // 创建并保存 MoodRecord
            let record1 = MoodRecord(mood: .positive, shelf: sampleShelf1)
            let record2 = MoodRecord(mood: .negative, shelf: sampleShelf1)
            
            context.insert(record1)
            context.insert(record2)
            try context.save()
            
            // 创建并保存 Journal
            let journals1 = [
                Journal(
                    type: .normal,
                    content: "今天工作很顺利",
                    emotion: .happiness,
                    shelf: sampleShelf1
                ),
                Journal(
                    type: .bible,
                    content: "感谢主的带领",
                    emotion: .surprise,
                    bibleReference: "约翰福音 3:16",
                    shelf: sampleShelf1
                ),
                Journal(
                    type: .gratitude,
                    content: "感谢同事的帮助",
                    emotion: .happiness,
                    gratitudeTarget: "张同事",
                    shelf: sampleShelf1
                )
            ]
            
            // 设置不同的创建时间
            record1.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            record2.createdAt = Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date()
            journals1[0].createdAt = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
            journals1[1].createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            journals1[2].createdAt = Date()
            
            for journal in journals1 {
                context.insert(journal)
            }
            try context.save()
            
        } catch {
            fatalError("Could not create preview container: \(error.localizedDescription)")
        }
    }
}

// 添加便利访问方法
extension PreviewSampleData {
    var samplePHQTests: [PHQTest] {
        [samplePHQTest1, samplePHQTest2, samplePHQTest3]
    }
    
    var sampleDASS21Tests: [DASS21Test] {
        [sampleDASS21Test1, sampleDASS21Test2]
    }
    
    // 用于预览的单个DASS21Test
    var sampleDASS21Test: DASS21Test {
        sampleDASS21Test1
    }
} 
