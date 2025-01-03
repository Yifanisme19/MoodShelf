//
//  ContentView.swift
//  MoodShelf
//
//  Created by LEE YI FAN on 12/12/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Shelf.createdAt) private var shelves: [Shelf]
    @State private var showingAddShelf = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    NavigationLink {
                        AssessmentSelectionView()
                    } label: {
                        AssessmentEntryCard()
                    }
                    .buttonStyle(.plain)
                    
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                        ForEach(shelves) { shelf in
                            NavigationLink(value: shelf) {
                                VStack(spacing: 16) {
                                    MoodHeatmap(shelf: shelf)
                                    QuickMoodRecorder { mood in
                                        addMoodRecord(mood, to: shelf)
                                    }
                                    
                                    HStack {
                                        Text("View Details")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(20)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Button {
                            showingAddShelf = true
                        } label: {
                            AddShelfCard()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("MoodShelf")
            .navigationDestination(for: Shelf.self) { shelf in
                ShelfDetailView(shelf: shelf)
            }
            .sheet(isPresented: $showingAddShelf) {
                AddShelfView()
            }
            .sheet(isPresented: $isFirstTime) {
                OnBoardingView()
                    .interactiveDismissDisabled()
                    .presentationCornerRadius(20)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
    
    private func addMoodRecord(_ type: MoodType, to shelf: Shelf) {
        withAnimation {
            let record = MoodRecord(mood: type, shelf: shelf)
            modelContext.insert(record)
            shelf.addMoodRecord(record)
        }
    }
}

struct AddShelfCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
            
            Text("New Category")
                .font(.headline)
            
            Text("Create a category that records and tracks the emotional changes you experience during a particular event, activity, or state.")
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.shared.container)
}
