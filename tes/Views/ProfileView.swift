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
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // USER NAME
                    
                    Text("\(userName)")
                        .font(.system(size: 32, weight: .bold))
                    
                    
                    // CONSISTENCY CARD
                    
                    HStack {
                        
                        Text("Tingkat\nkonsistensimu")
                            .font(.system(size:30))
                        
                        Spacer()
                        
                        Text("33%")
                            .font(.system(size:50, weight:.bold))
                            .foregroundColor(Color.primaryBrand)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius:10)
                            .stroke(Color.primaryBrand.opacity(0.5))
                    )
                    
                    
                    // RECOMMENDATION BUTTON
                    
                    HStack {
                        
                        Text("Atur Rekomendasi Kegiatan")
                            .font(.system(size:16, weight:.medium))
                        
                        Spacer()
                        
                        Image(systemName:"chevron.right")
                    }
                    .padding()
                    .background(Color.primaryBrand.opacity(0.25))
                    .cornerRadius(10)
                    
                    
                    Divider()
                    
                    
                    // AI SUGGESTION
                    
                    Text("Belum tau kegiatan apa yang cocok dengan ceritamu? Coba bantuan AI sekarang...")
                        .font(.system(size:15))
                        .foregroundColor(.gray)
                    
                    
                    HStack {
                        
                        Spacer()
                        
                        HStack(spacing:6) {
                            
                            Text("Selengkapnya")
                                .fontWeight(.semibold)
                            
                            Image(systemName:"chevron.right")
                        }
                    }
                    
                }
                .padding(24)
            }
//            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(userName: "Iyan")
}
