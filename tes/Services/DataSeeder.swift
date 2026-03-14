//
//  DataSeeder.swift
//  tes
//
//  Created by Muhammad Satria Dharma on 12/03/26.
//

import Foundation
import SwiftData

@MainActor
struct DataSeeder {
    static func seed(context: ModelContext) {
        let descriptor = FetchDescriptor<ActivityItem>()
        
        do {
            let existingCount = try context.fetchCount(descriptor)
            
            if existingCount == 0 {
                let initialActivities = [
                    // Kategori Kesehatan
                    ActivityItem(name: "Minum Air 2L", category: "Kesehatan"),
                    ActivityItem(name: "Tidur 8 Jam", category: "Kesehatan"),
                    ActivityItem(name: "Cek Kesehatan", category: "Kesehatan"),
                    
                    // Kategori Kebugaran
                    ActivityItem(name: "Lari 30 Menit", category: "Kebugaran"),
                    ActivityItem(name: "Plank 1 Menit", category: "Kebugaran"),
                    
                    // Kategori Pengetahuan
                    ActivityItem(name: "Baca Artikel AI", category: "Pengetahuan"),
                    ActivityItem(name: "Belajar Swift Syntax", category: "Pengetahuan")
                ]
                
                for item in initialActivities {
                    context.insert(item)
                }
                
                try context.save()
                print("Database berhasil di-seed dengan template awal.")
            }
        } catch {
            print("Gagal melakukan seeding: \(error.localizedDescription)")
        }
    }
}
