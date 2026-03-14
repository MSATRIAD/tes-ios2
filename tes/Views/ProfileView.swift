import SwiftUI
import SwiftData

struct ProfileView: View {
    
    let userName: String
    var selectedActivities: Set<String> = []
    
    @Query private var allCompletedTasks: [CompletedTask]
    
    @State private var showingResetFlow = false
    
    var consistencyPercentage: Int {
        guard !selectedActivities.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var totalConsistency: Double = 0
        
        for activityName in selectedActivities {
            let taskDates = allCompletedTasks
                .filter { $0.activityName == activityName }
                .map { calendar.startOfDay(for: $0.date) }
            
            let startDate = taskDates.min() ?? today
            let components = calendar.dateComponents([.day], from: startDate, to: today)
            let activeDays = max((components.day ?? 0) + 1, 1)
            
            let completedDays = Set(taskDates).count
            let activityRatio = Double(completedDays) / Double(activeDays)
            totalConsistency += activityRatio
        }
        
        let finalRatio = totalConsistency / Double(selectedActivities.count)
        return Int(min(max(finalRatio, 0.0), 1.0) * 100)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("\(userName)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tingkat")
                                Text("konsistensimu")
                            }
                            .font(.system(size: 26, weight: .medium))
                            .foregroundColor(Color.textPrimary)
                            
                            Spacer()
                            
                            Text("\(consistencyPercentage)%")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(Color.primaryBrand)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Dihitung berdasarkan rata-rata keberhasilan tiap aktivitas sejak pertama kali kamu memulainya.")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            if !allCompletedTasks.isEmpty {
                                Text("Berdasarkan \(totalActiveDaysText).")
                                    .font(.caption2)
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                        }
                        .lineSpacing(4)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primaryBrand.opacity(0.5), lineWidth: 2)
                    )
                    
                    // KUNCI PERBAIKAN: Menggunakan Button & fullScreenCover alih-alih NavigationLink
                    Button {
                        showingResetFlow = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Atur Ulang Aktivitas")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Ubah daftar target harianmu")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "slider.horizontal.3")
                                .font(.title3)
                        }
                        .padding()
                        .background(Color.primaryBrand.opacity(0.15))
                        .foregroundColor(Color.primaryBrand)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .fullScreenCover(isPresented: $showingResetFlow) {
                        NavigationStack {
                            CategorySelectionView(userName: userName, isFromProfile: true, isPresented: $showingResetFlow)
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.blue)
                            Text("Bantuan Pintar")
                                .font(.headline)
                        }
                        
                        Text("Gunakan AI untuk menganalisis diary-mu dan memberikan saran aktivitas yang lebih personal sesuai mood-mu.")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: RecommendationView()) {
                                HStack(spacing: 6) {
                                    Text("Tanya AI")
                                        .fontWeight(.semibold)
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(24)
            }
            .background(Color.backgroundApp)
        }
    }
    
    private var totalActiveDaysText: String {
        let calendar = Calendar.current
        guard let firstDate = allCompletedTasks.map({ $0.date }).min() else { return "0 hari" }
        let diff = calendar.dateComponents([.day], from: calendar.startOfDay(for: firstDate), to: calendar.startOfDay(for: Date()))
        let days = (diff.day ?? 0) + 1
        return "\(days) hari perjalananmu"
    }
}
