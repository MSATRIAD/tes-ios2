//
//  GeminiService.swift
//  tes
//
//  Created by Muhammad Satria Dharma on 10/03/26.
//

import Foundation
import GoogleGenerativeAI

class GeminiService {
    private let apiKey = "AIzaSyA8BzB9PFoi3CUjnkesMnAQcWfadnEJ5LA"
    private let model: GenerativeModel

    init() {
        self.model = GenerativeModel(
            name: "gemini-2.5-flash",
            apiKey: apiKey,
            generationConfig: GenerationConfig(responseMIMEType: "application/json")
        )
    }

    func getRecommendation(input: String) async throws -> TrackerModel? {
        let prompt = """
        User input: "\(input)"
        Berikan 1 rekomendasi tracker kebiasaan (habit tracker) untuk menyeimbangkan atau mendukung gaya hidup tersebut.
        Output harus berupa JSON murni dengan format persis seperti ini:
        {
          "title": "Nama Tracker (contoh: Water Tracker)",
          "icon": "nama.sf.symbol (contoh: drop.fill)",
          "description": "Alasan singkat (maksimal 2 kalimat)",
          "color": "blue, orange, green, red, atau purple"
        }
        """

        let response = try await model.generateContent(prompt)
        
        guard let text = response.text, let data = text.data(using: .utf8) else {
            return nil
        }

        let decoded = try JSONDecoder().decode(TrackerModel.self, from: data)
        return decoded
    }
}
