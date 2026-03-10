//
//  TrackerViewModel.swift
//  tes
//
//  Created by Muhammad Satria Dharma on 10/03/26.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class TrackerViewModel: ObservableObject {
    @Published var recommendation: TrackerModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = GeminiService()

    func analyze(text: String) {
        guard !text.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        recommendation = nil
        
        Task {
            do {
                let result = try await service.getRecommendation(input: text)
                self.recommendation = result
            } catch {
                self.errorMessage = "Error: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
