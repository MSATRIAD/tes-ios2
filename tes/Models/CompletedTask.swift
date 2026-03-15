//
//  CompletedTask.swift
//  tes
//
//  Created by Muhammad Satria Dharma on 12/03/26.
//

import Foundation
import SwiftData

@Model
class CompletedTask {
    var id: UUID = UUID()
    var activityName: String
    var category: String
    var date: Date
    
    init(activityName: String, category: String, date: Date = Date()) {
        self.activityName = activityName
        self.category = category
        self.date = date
    }
}
