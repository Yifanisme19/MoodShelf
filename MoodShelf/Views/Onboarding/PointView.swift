//
//  PointView.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import SwiftUI

struct PointView: View {
    var symbol: String
    var title: String
    var subTitle: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Color.green.gradient)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.gray)
            }
            
        }
        .padding(.horizontal, 14)
    }
}

#Preview {
    PointView(symbol: "chart.xyaxis.line", title: "Visual Charts", subTitle: "View your mood using eye-catching graphic representations.")
}
