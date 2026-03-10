//
//  TrackerRecommendation.swift
//  tes
//
//  Created by Muhammad Satria Dharma on 10/03/26.
//

import Foundation
import SwiftUI

struct TrackerModel: Identifiable, Codable {
    var id = UUID()
    let title: String
    let icon: String
    let description: String
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case title, icon, description, color
    }
    
    var themeColor: Color {
        switch color.lowercased() {
        case "blue": return .blue
        case "orange": return .orange
        case "green": return .green
        case "red": return .red
        case "purple": return .purple
        default: return .primary
        }
    }
}
