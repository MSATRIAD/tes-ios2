import SwiftUI
import UIKit

struct ActivityRecommendationView: View {
    
    let selectedCategories: Set<String>
    
    @State private var selectedActivities: Set<String> = []
    @State private var expandedCategories: Set<String> = []
    @State private var goToHome = false
    
    var body: some View {
        
        NavigationStack {
            
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
            .background(Color(hex:"#F8FAFC"))
            
            
            // Navigation
            
            .navigationDestination(isPresented: $goToHome) {
                
                HomeViews(
                    selectedActivities: selectedActivities
                )
            }
        }
    }
}

extension ActivityRecommendationView {
    
    // MARK: Header
    
    var header: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Aktivitas Rekomendasi")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex:"#1E293B"))
            
            Text("Pilih minimal satu aktivitas yang ingin kamu mulai.")
                .font(.subheadline)
                .foregroundColor(Color(hex:"#64748B"))
            
            Text("\(selectedActivities.count) dipilih")
                .font(.caption)
                .foregroundColor(Color(hex:"#64748B"))
        }
    }
    
    
    // MARK: Activity Sections
    
    var activitySections: some View {
        
        VStack(spacing: 18) {
            
            ForEach(selectedCategories.sorted(), id:\.self) { category in
                
                categorySection(category)
                
            }
        }
    }
    
    
    // MARK: Continue Button
    
    var continueButton: some View {
        
        Button {
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            goToHome = true
            
        } label: {
            
            Text("Mulai Perjalananmu (\(selectedActivities.count))")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    selectedActivities.isEmpty ?
                    Color.gray.opacity(0.2) :
                    Color(hex:"#4F46E5")
                )
                .foregroundColor(.white)
                .cornerRadius(14)
        }
        .disabled(selectedActivities.isEmpty)
        .padding(24)
    }
}

extension ActivityRecommendationView {
    
    
    // MARK: Category Section
    
    func categorySection(_ category:String) -> some View {
        
        let activities = activitiesForCategory(category)
        let isExpanded = expandedCategories.contains(category)
        
        return VStack(spacing:12) {
            
            
            // Category Header
            
            HStack {
                
                Image(systemName: iconForCategory(category))
                    .foregroundColor(Color(hex:"#4F46E5"))
                
                Text(category)
                    .font(.system(size:18, weight:.semibold))
                    .foregroundColor(Color(hex:"#1E293B"))
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.03), radius: 6, x:0, y:3)
            .onTapGesture {
                
                withAnimation(.easeInOut) {
                    
                    if isExpanded {
                        expandedCategories.remove(category)
                    } else {
                        expandedCategories.insert(category)
                    }
                }
            }
            
            
            // Activities
            
            if isExpanded {
                
                VStack(spacing:12) {
                    
                    ForEach(activities, id:\.self) { activity in
                        
                        activityCard(activity)
                        
                    }
                }
            }
        }
    }
    
    
    // MARK: Activity Card
    
    func activityCard(_ activity:String) -> some View {
        
        let isSelected = selectedActivities.contains(activity)
        
        return HStack(spacing:16) {
            
            Image(systemName: iconForActivity(activity))
                .font(.system(size:18))
                .foregroundColor(isSelected ? .white : Color(hex:"#4F46E5"))
                .frame(width:42,height:42)
                .background(
                    isSelected ?
                    Color(hex:"#4F46E5") :
                    Color(hex:"#EEF2FF")
                )
                .cornerRadius(12)
            
            
            Text(activity)
                .font(.system(size:17, weight:.medium))
                .foregroundColor(Color(hex:"#1E293B"))
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(
                    isSelected ?
                    Color(hex:"#4F46E5") :
                    Color.gray.opacity(0.4)
                )
        }
        .padding()
        .background(isSelected ? Color(hex:"#EEF2FF") : Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius:16)
                .stroke(isSelected ? Color(hex:"#4F46E5") : Color.clear, lineWidth:1.5)
        )
        .shadow(color: Color.black.opacity(0.03), radius:6, x:0, y:3)
        .onTapGesture {
            
            withAnimation(.spring(response:0.25, dampingFraction:0.8)) {
                
                toggleActivity(activity)
                haptic()
            }
        }
    }
    
    
    // MARK: Activity Logic
    
    func toggleActivity(_ activity:String) {
        
        if selectedActivities.contains(activity) {
            selectedActivities.remove(activity)
        } else {
            selectedActivities.insert(activity)
        }
    }
    
    
    // MARK: Activity Data
    
    func activitiesForCategory(_ category:String) -> [String] {
        
        switch category {
            
        case "Kesehatan":
            return ["Minum Air 2L","Tidur 8 Jam","Cek Kesehatan"]
            
        case "Kebugaran":
            return ["Olahraga 30 Menit","Stretching Pagi","Jalan 10.000 Langkah"]
            
        case "Pengetahuan":
            return ["Membaca 10 Halaman","Belajar Skill Baru","Menonton Edukasi"]
            
        case "Keuangan":
            return ["Catat Pengeluaran","Menabung Harian","Belajar Investasi"]
            
        case "Karir":
            return ["Belajar Skill Karir","Update CV","Networking"]
            
        case "Mental":
            return ["Meditasi 10 Menit","Jurnal Harian","Digital Detox"]
            
        default:
            return []
        }
    }
    
    
    // MARK: Icons
    
    func iconForCategory(_ category:String) -> String {
        
        switch category {
            
        case "Kesehatan": return "waveform.path.ecg"
        case "Kebugaran": return "dumbbell.fill"
        case "Pengetahuan": return "book.fill"
        case "Keuangan": return "dollarsign"
        case "Karir": return "briefcase.fill"
        case "Mental": return "brain.head.profile"
            
        default: return "circle"
        }
    }
    
    
    func iconForActivity(_ activity:String) -> String {
        
        switch activity {
            
        case "Minum Air 2L": return "drop.fill"
        case "Tidur 8 Jam": return "bed.double.fill"
        case "Cek Kesehatan": return "cross.fill"
        case "Olahraga 30 Menit": return "figure.run"
        case "Stretching Pagi": return "figure.cooldown"
        case "Jalan 10.000 Langkah": return "figure.walk"
        case "Membaca 10 Halaman": return "book.fill"
        case "Belajar Skill Baru": return "brain.head.profile"
        case "Menonton Edukasi": return "play.rectangle.fill"
        case "Catat Pengeluaran": return "list.bullet.rectangle"
        case "Menabung Harian": return "banknote.fill"
        case "Belajar Investasi": return "chart.line.uptrend.xyaxis"
        case "Belajar Skill Karir": return "briefcase.fill"
        case "Update CV": return "doc.text.fill"
        case "Networking": return "person.3.fill"
        case "Meditasi 10 Menit": return "leaf.fill"
        case "Jurnal Harian": return "pencil"
        case "Digital Detox": return "iphone.slash"
            
        default: return "circle"
        }
    }
    
    
    // MARK: Haptic
    
    func haptic() {
        UIImpactFeedbackGenerator(style:.light).impactOccurred()
    }
}

#Preview {
    ActivityRecommendationView(
        selectedCategories:["Kesehatan","Karir"]
    )
}
