//
//  ProfileView.swift
//  tes
//
//  Created by Yusuf Dwi Kurniawan on 12/03/26.
//

import SwiftUI

struct ProfileView: View {
    
    let userName: String
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing:20) {
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size:80))
                    .foregroundColor(Color.primaryBrand)
                
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(userName: "Iyan")
}
