import SwiftUI

struct SplashView: View {
    
    @State private var isActive = false
    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0.5
    
    // MARK: - App Storage

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    @AppStorage("userName") var storedUserName: String = ""
    
    @AppStorage("selectedActivitiesData") var selectedActivitiesData: String = ""

    var selectedActivitiesSet: Set<String> {
        guard let data = selectedActivitiesData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            return [] // Jika kosong atau gagal, kembalikan Set kosong
        }
        return decoded
    }
    
    var body: some View {
        
        if isActive {
            // LOGIKA NAVIGASI:
            if hasCompletedOnboarding {
                BottomNavbar(userName: storedUserName, selectedActivities: selectedActivitiesSet)
            } else {
                UserInfoView()
            }
            
        } else {
            ZStack {
                Color(hex: "#F2B705")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image("Logo-NewSkin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("Impruv")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                .opacity(opacity)
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    scale = 1
                    opacity = 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
