//
//  Category.swift
//  tes
//
//  Created by Yusuf Dwi Kurniawan on 11/03/26.
//
import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}
let categories = [
    Category(name: "Kesehatan", icon: "heart.text.square"),
    Category(name: "Kebugaran", icon: "dumbbell"),
    Category(name: "Pengetahuan", icon: "book"),
    Category(name: "Keuangan", icon: "dollarsign.square"),
    Category(name: "Karir", icon: "briefcase"),
    Category(name: "Mental", icon: "brain.head.profile")
]
