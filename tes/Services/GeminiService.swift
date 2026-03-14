import Foundation
import GoogleGenerativeAI

// Model untuk hasil dari AI
struct ActivityRecommendation: Codable, Hashable {
    let category: String
    let activity_name: String
    let reason: String
}

struct AIResponse: Codable {
    let recommendations: [ActivityRecommendation]
}

class GeminiService {
    private let model: GenerativeModel
    
    init(apiKey: String) {
        let config = GenerationConfig(
            responseMIMEType: "application/json"
        )
        self.model = GenerativeModel(
            name: "gemini-2.5-flash",
            apiKey: apiKey,
            generationConfig: config,
            systemInstruction: ModelContent(role: "system", parts: [
                .text("""
                Anda adalah asisten pemberi saran aktivitas kebiasaan (habit). 
                Buatlah TEPAT 3 rekomendasi aktivitas baru berdasarkan cerita user.
                
                ATURAN KATEGORI KETAT:
                Value untuk "category" HANYA BOLEH salah satu dari: "Kesehatan", "Kebugaran", atau "Pengetahuan".
                Jangan membuat kategori lain.
                
                Output harus berupa JSON murni tanpa format markdown:
                {
                  "recommendations": [
                    {"category": "Kesehatan", "activity_name": "...", "reason": "..."},
                    {"category": "Kebugaran", "activity_name": "...", "reason": "..."},
                    {"category": "Pengetahuan", "activity_name": "...", "reason": "..."}
                  ]
                }
                """)
            ])
        )
    }
    
    func fetchThreeRecommendations(story: String, existingNames: [String]) async throws -> [ActivityRecommendation] {
        let prompt = "Cerita: \(story). Jangan rekomendasikan aktivitas yang sudah ada: \(existingNames.joined(separator: ", "))"
        let response = try await model.generateContent(prompt)
        
        guard let text = response.text else {
            return []
        }
        
        var cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedText.hasPrefix("```json") {
            cleanedText.removeFirst(7)
        } else if cleanedText.hasPrefix("```") {
            cleanedText.removeFirst(3)
        }
        if cleanedText.hasSuffix("```") {
            cleanedText.removeLast(3)
        }
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = cleanedText.data(using: .utf8) else {
            return []
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(AIResponse.self, from: data)
            return decodedResponse.recommendations
        } catch {
            print("❌ Gagal parsing JSON Gemini: \(error.localizedDescription)")
            print("Teks mentah: \(cleanedText)")
            return []
        }
    }
}
