//
//  OnBoardingView.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import SwiftUI

struct OnBoardingView: View {
    /// Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var animatedRows: Set<Int> = []
    @Environment(\.colorScheme) private var colorScheme
    
    private let features: [(symbol: String, title: String, subTitle: String)] = [
        ("bolt.horizontal", "Mood Tracking", "Record your mood in few seconds."),
        ("book", "Journaling", "Record emotion using different types of journal styles."),
        ("heart.text.clipboard", "Scientific Self-Test", "A self-test questionnaire to measure your mental health"),
        ("chart.xyaxis.line", "Visual Charts", "View your mood using eye-catching graphic representations.")
    ]
    var body: some View {
        ZStack{
            VStack{
                Text("What's New in the MoodShelf App")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 65)
                    .padding(.bottom, 35)
                
                VStack(alignment: .leading, spacing: 25) {
                    ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                        PointView(symbol: feature.symbol, title: feature.title, subTitle: feature.subTitle)
                            .offset(x: animatedRows.contains(index) ? 0 : -UIScreen.main.bounds.width)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index) * 0.1), value: animatedRows.contains(index))
                    }
                }
                .onAppear {
                    animateRows()
                }
                
                Spacer(minLength: 10)
                
                Button {
                    isFirstTime = false
                } label: {
                    Text("Get Started")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.green.gradient, in: .rect(cornerRadius: 12))
                        .contentShape(.rect)
                }
                .padding(14)
            }
            
            ShiningStarsView()
        }
    }
    
    private func animateRows() {
        for index in features.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                animatedRows.insert(index)
            }
        }
    }
}

struct ShiningStarsView: View {
    let starCount = 10
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<starCount, id: \.self) { index in
                ShiningStarView()
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height/5)
                    )
            }
        }
    }
}

struct ShiningStarView: View {
    @State private var isShining = false
    
    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: 20))
            .foregroundColor(.yellow)
            .opacity(isShining ? 1 : 0)
            .scaleEffect(isShining ? 1 : 0.5)
            .animation(
                Animation.easeInOut(duration: 1)
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...2)),
                value: isShining
            )
            .onAppear {
                isShining = true
            }
    }
}

#Preview {
    OnBoardingView()
}
