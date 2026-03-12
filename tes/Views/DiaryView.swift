//
//  DiaryView.swift
//  tes
//
//  Created by Yusuf Dwi Kurniawan on 12/03/26.
//

import SwiftUI

struct DiaryView: View {
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                Text("Diary Page")
                    .font(.title)
            }
            .navigationTitle("Diary")
        }
    }
}

#Preview {
    DiaryView()
}
