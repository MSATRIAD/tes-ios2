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
    
    func getRecommendations(userStory: String) async -> [ActivityRecommendation] {
        isProcessing = true
        defer { isProcessing = false }
        
        let descriptor = FetchDescriptor<ActivityItem>()
        let existingItems = (try? modelContext.fetch(descriptor)) ?? []
        let existingNames = existingItems.map { $0.name }
        
        do {
            return try await aiService.fetchThreeRecommendations(story: userStory, existingNames: existingNames)
        } catch {
            print(" Error Fetching: \(error.localizedDescription)")
            return []
        }
    }
}
