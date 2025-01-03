//
//  AboutDeveloperView.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 13/12/2024.
//

import SwiftUI

struct AboutDeveloperView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Text("👋")
                        .font(.largeTitle)
                        
                    Text("Hi! I'm Yi Fan, the developer behind MoodShelf. \nI hope you're enjoying the app!")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    Text("Below are some places where you can follow updates from me.")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .listRowBackground(Color.clear)
            
            Section {
                Link(destination: URL(string: "https://www.threads.net/@yifanisme")!) {
                    Label("Threads", systemImage: "link")
                }
                
            }
            
        }
        .navigationTitle("About Developer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutDeveloperView()
    }
}
