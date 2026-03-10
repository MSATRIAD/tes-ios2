//
//  TrackerCardView.swift
//  tes
//
//  Created by Muhammad Satria Dharma on 10/03/26.
//

import SwiftUI

struct TrackerCardView: View {
    let tracker: TrackerModel
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: tracker.icon)
                .font(.system(size: 60))
                .foregroundColor(tracker.themeColor)
            
            Text(tracker.title)
                .font(.title2)
                .bold()
            
            Text(tracker.description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(tracker.themeColor.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(tracker.themeColor.opacity(0.3), lineWidth: 2)
        )
    }
}

#Preview {
    TrackerCardView(tracker: TrackerModel(
        title: "Body Stretching",
        icon: "figure.walk",
        description: "Banyak duduk tidak baik, yuk peregangan 5 menit!",
        color: "orange"
    ))
    .padding()
}
