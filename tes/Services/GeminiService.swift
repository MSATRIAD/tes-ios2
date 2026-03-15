import Foundation
import GoogleGenerativeAI

struct ActivityRecommendation: Codable, Hashable {
    let category: String
    let activity_name: String
    let reason: String
}

struct AIResponse: Codable {
    let is_clear: Bool
    let message: String?
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
                
                TUGAS UTAMA:
                1. Analisis cerita user. Apakah masuk akal dan bisa dipahami?
                2. Jika cerita user TIDAK JELAS (berisi kata acak/gibberish, ketikan asal, atau sama sekali tidak berhubungan dengan rutinitas/habit/pengembangan diri), atur "is_clear" menjadi false, dan berikan pesan ramah di "message" yang meminta user menjelaskan ulang ceritanya.
                3. Jika cerita JELAS, atur "is_clear" menjadi true, kosongkan "message", dan buat TEPAT 3 rekomendasi aktivitas baru.
                
                ATURAN KATEGORI KETAT (jika jelas):
                Value untuk "category" HANYA BOLEH salah satu dari: "Kesehatan", "Kebugaran", atau "Pengetahuan". Jangan membuat kategori lain.
                
                Output harus berupa JSON murni tanpa format markdown:
                {
                  "is_clear": true/false,
                  "message": "Pesan balasan jika cerita tidak jelas...",
                  "recommendations": [
                    {"category": "Kesehatan", "activity_name": "...", "reason": "..."},
                    {"category": "Kebugaran", "activity_name": "...", "reason": "..."}
                  ]
                }
                """)
            ])
        )
    }

    func fetchThreeRecommendations(story: String, existingNames: [String]) async throws -> AIResponse {
        let prompt = "Cerita: \(story). Jangan rekomendasikan aktivitas yang sudah ada: \(existingNames.joined(separator: ", "))"
        let response = try await model.generateContent(prompt)
        
        guard let text = response.text else {
            throw NSError(domain: "Gemini", code: 0, userInfo: [NSLocalizedDescriptionKey: "AI tidak merespon teks"])
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
            throw NSError(domain: "Gemini", code: 1, userInfo: [NSLocalizedDescriptionKey: "Gagal konversi ke Data"])
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(AIResponse.self, from: data)
            return decodedResponse
        } catch {
            print("Gagal parsing JSON Gemini: \(error.localizedDescription)")
            print("Teks mentah: \(cleanedText)")
            throw error
        }
    }
}
