//
//  ActivityModels.swift
//  tes
//
//  Created by Muhammad Satria Dharma on 12/03/26.
//

import Foundation
import SwiftData

@Model
class ActivityItem {
    var id: UUID
    var name: String
    var category: String
    var createdAt: Date
    
    init(name: String, category: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.createdAt = Date()
    }
}
