import SwiftUI
import SwiftData

struct ActivityRecommendationView: View {
    
    let selectedCategories: Set<String>
    let userName: String
    
    var isFromProfile: Bool = false
    @Binding var isPresented: Bool
    
    @Query private var allActivityItems: [ActivityItem]
    
    @State private var selectedActivities: Set<String> = []
    @State private var expandedCategories: Set<String> = []
    @State private var goToHome = false
    
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("selectedActivitiesData") var selectedActivitiesData: String = ""
    
    init(selectedCategories: Set<String>, userName: String, isFromProfile: Bool = false, isPresented: Binding<Bool> = .constant(true)) {
        self.selectedCategories = selectedCategories
        self.userName = userName
        self.isFromProfile = isFromProfile
        self._isPresented = isPresented
    }
    
    var activitiesByCategory: [String: [String]] {
        var dict: [String: [String]] = [:]
        for category in selectedCategories {
            let itemsInCategory = allActivityItems.filter { $0.category == category }
            dict[category] = itemsInCategory.map { $0.name }
        }
        return dict
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    activitySections
                }
                .padding(24)
            }
            continueButton
        }
        .background(Color.backgroundApp)
        .navigationDestination(isPresented: $goToHome) {
            BottomNavbar(userName: userName, selectedActivities: selectedActivities)
        }
    }
}

extension ActivityRecommendationView {
    
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Aktivitas Rekomendasi")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.textPrimary)
            
            Text("Pilih minimal satu aktivitas yang ingin kamu mulai.")
                .font(.subheadline)
                .foregroundColor(Color.textSecondary)
            
            Text("\(selectedActivities.count) dipilih")
                .font(.caption)
                .foregroundColor(Color.textSecondary)
        }
    }
    
    var activitySections: some View {
        VStack(spacing: 18) {
            ForEach(selectedCategories.sorted(), id:\.self) { category in
                categorySection(category)
            }
        }
    }
    
    var continueButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            if let encoded = try? JSONEncoder().encode(selectedActivities) {
                selectedActivitiesData = String(data: encoded, encoding: .utf8) ?? ""
            }
            
            if isFromProfile {
                // Jika dari Profile, tutup saja modal-nya. Home dan Profile akan otomatis update!
                isPresented = false
            } else {
                // Jika dari Onboarding pertama kali, tandai selesai dan buka Home
                hasCompletedOnboarding = true
                goToHome = true
            }
            
        } label: {
            Text(isFromProfile ? "Simpan Perubahan" : "Mulai Perjalananmu (\(selectedActivities.count))")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedActivities.isEmpty ? Color.gray.opacity(0.2) : Color.primaryBrand)
                .foregroundColor(.white)
                .cornerRadius(14)
        }
        .disabled(selectedActivities.isEmpty)
        .padding(24)
    }
}

extension ActivityRecommendationView {
    
    func categorySection(_ category:String) -> some View {
        let activities = activitiesByCategory[category] ?? []
        let isExpanded = expandedCategories.contains(category)
        
        return VStack(spacing:12) {
            HStack {
                Image(systemName: iconForCategory(category))
                    .foregroundColor(Color.primaryBrand)
                
                Text(category)
                    .font(.system(size:18, weight:.semibold))
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.03), radius: 6, x:0, y:3)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut) {
                    if isExpanded { expandedCategories.remove(category) }
                    else { expandedCategories.insert(category) }
                }
            }
            
            if isExpanded {
                VStack(spacing:12) {
                    ForEach(activities, id:\.self) { activity in
                        activityCard(activity)
                    }
                }
            }
        }
    }
    
    func activityCard(_ activity:String) -> some View {
        let isSelected = selectedActivities.contains(activity)
        
        return Button {
            withAnimation(.spring(response:0.25, dampingFraction:0.8)) {
                toggleActivity(activity)
                haptic()
            }
        } label: {
            HStack(spacing:16) {
                Image(systemName: iconForActivity(activity))
                    .font(.system(size:18))
                    .foregroundColor(isSelected ? .white : Color.primaryBrand)
                    .frame(width:42,height:42)
                    .background(isSelected ? Color.primaryBrand : Color.iconBackground)
                    .cornerRadius(12)
                
                Text(activity)
                    .font(.system(size:17, weight:.medium))
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color.primaryBrand : Color.gray.opacity(0.4))
            }
            .padding()
            .contentShape(Rectangle())
            .background(isSelected ? Color.iconBackground.opacity(0.6) : Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius:16)
                    .stroke(isSelected ? Color.primaryBrand : Color.clear, lineWidth:1.5)
            )
            .shadow(color: Color.black.opacity(0.03), radius:6, x:0, y:3)
        }
        .buttonStyle(.plain)
    }
    
    func toggleActivity(_ activity:String) {
        if selectedActivities.contains(activity) { selectedActivities.remove(activity) }
        else { selectedActivities.insert(activity) }
    }
    
    func iconForCategory(_ category:String) -> String {
        switch category {
        case "Kesehatan": return "waveform.path.ecg"
        case "Kebugaran": return "dumbbell.fill"
        case "Pengetahuan": return "book.fill"
        default: return "circle"
        }
    }
    
    func iconForActivity(_ activity:String) -> String {
        switch activity {
        case "Minum Air 2L": return "drop.fill"
        case "Tidur 8 Jam": return "bed.double.fill"
        case "Cek Kesehatan": return "cross.fill"
        case "Lari 30 Menit": return "figure.run"
        case "Plank 1 Menit": return "figure.cooldown"
        case "Baca Artikel AI": return "book.fill"
        case "Belajar Swift Syntax": return "brain.head.profile"
        default: return "circle"
        }
    }
    
    func haptic() {
        UIImpactFeedbackGenerator(style:.light).impactOccurred()
    }
}
