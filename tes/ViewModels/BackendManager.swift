import Foundation
import SwiftData
import Observation

@MainActor
@Observable
class BackendManager {
    var isProcessing: Bool = false
    
    private var modelContext: ModelContext
    private let aiService: GeminiService
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.aiService = GeminiService(apiKey: APIKey.default)
    }
    
    func getRecommendationsOnly(userStory: String) async -> (recommendations: [ActivityRecommendation], errorMsg: String?) {
        isProcessing = true
        defer { isProcessing = false }
        
        let descriptor = FetchDescriptor<ActivityItem>()
        let existingItems = (try? modelContext.fetch(descriptor)) ?? []
        let existingNames = existingItems.map { $0.name }
        
        do {
            let result = try await aiService.fetchThreeRecommendations(story: userStory, existingNames: existingNames)
            
            if result.is_clear {
                return (result.recommendations, nil)
            } else {
                return ([], result.message ?? "Maaf, ceritamu kurang jelas. Bisa jelaskan lagi?")
            }
        } catch {
            print(" Error Fetching: \(error.localizedDescription)")
            return ([], "Terjadi kesalahan saat menghubungi sistem. Coba lagi ya.")
        }
    }
}
