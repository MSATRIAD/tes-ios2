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
                    ActivityItem(name: "Makan satu buah dan sayuran", category: "Kesehatan"),
                    ActivityItem(name: "Tidur 7–9 jam", category: "Kesehatan"),
                    ActivityItem(name: "Hindari zat beracun", category: "Kesehatan"),
                    
                    // Kategori Kebugaran
                    ActivityItem(name: "Berjalan kaki setidaknya 10 menit", category: "Kebugaran"),
                    ActivityItem(name: "Plank 1 Menit", category: "Kebugaran"),
                    
                    // Kategori Pengetahuan
                    ActivityItem(name: "Baca Artikel", category: "Pengetahuan"),
                    ActivityItem(name: "Membaca Buku 20 menit", category: "Pengetahuan")
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
