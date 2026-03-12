//
//  BottomNavbar.swift
//  tes
//

import SwiftUI

struct BottomNavbar: View {
    
    let userName: String
    let selectedActivities: Set<String>
    
    var body: some View {
        
        TabView {
            
            // Habit Page
            
            HomeViews(
                userName: userName,
                selectedActivities: selectedActivities
            )
            .tabItem {
                Label("Habit", systemImage: "checkmark.circle.fill")
            }
            
            
            // Progress Page
            
            ProgressViewPage()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
            
            
            // Diary Page
            
            DiaryView()
                .tabItem {
                    Label("Diary", systemImage: "book.fill")
                }
            
            
            // Profile Page
            
            ProfileView(userName: userName)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(Color.primaryBrand)
    }
}

#Preview {
    
    BottomNavbar(
        userName: "Iyan",
        selectedActivities: [
            "Minum Air 2L",
            "Olahraga 30 Menit"
        ]
    )
}
