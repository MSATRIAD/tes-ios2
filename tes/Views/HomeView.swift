//
//  HomeView.swift
//  tes
//
//  Created by Muhammad Satria Dharma on 10/03/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = TrackerViewModel()
    @State private var inputText = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        TextEditor(text: $inputText)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        viewModel.analyze(text: inputText)
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Dapatkan Rekomendasi")
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(inputText.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(inputText.isEmpty || viewModel.isLoading)
                    .padding(.horizontal)

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }

                    if let tracker = viewModel.recommendation {
                        TrackerCardView(tracker: tracker)
                            .padding(.horizontal)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("AI Tracker")
            .animation(.spring(), value: viewModel.recommendation?.id)
        }
    }
}

#Preview {
    HomeView()
}
