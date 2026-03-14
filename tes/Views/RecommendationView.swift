import SwiftUI
import SwiftData

struct RecommendationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var manager: BackendManager?
    @State private var userStory = ""
    @State private var recommendations: [ActivityRecommendation] = []
    @State private var selectedActivities: Set<ActivityRecommendation> = []
    
    @AppStorage("selectedActivitiesData") var selectedActivitiesData: String = ""
    
    var userName: String = "Iyan"
    
    var body: some View {
        VStack(spacing: 0) {
            customNavigationBar
            
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    
                    // JUDUL PAGE
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Halo, \(userName)!")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                        Text("Aktivitas seperti apa yang kamu inginkan?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(red: 0.29, green: 0.24, blue: 0.16)) // Cokelat gelap
                    }
                    
                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            .background(Color.white)
                            .cornerRadius(20)
                        
                        TextEditor(text: $userStory)
                            .font(.system(size: 16))
                            .padding(16)
                            .frame(height: 200)
                            .scrollContentBackground(.hidden)
                        
                        // Tombol Kirim di Dalam Kotak
                        Button {
                            askAI()
                        } label: {
                            if manager?.isProcessing == true {
                                ProgressView().tint(.white)
                            } else {
                                Text("Kirim")
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(userStory.isEmpty ? Color.gray.opacity(0.3) : Color.primaryBrand)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(userStory.isEmpty || (manager?.isProcessing ?? false))
                        .padding(16)
                    }
                    
                    // DAFTAR SARAN KEGIATAN
                    if !recommendations.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Saran kegiatan:")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            ForEach(recommendations, id: \.activity_name) { item in
                                suggestionCard(item)
                            }
                        }
                    }
                }
                .padding(24)
            }
            
            // TOMBOL SELESAI
            if !recommendations.isEmpty {
                Button {
                    saveSelection()
                } label: {
                    Text("Selesai")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(selectedActivities.isEmpty ? Color.gray.opacity(0.2) : Color.primaryBrand)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .disabled(selectedActivities.isEmpty)
                .padding(24)
            }
        }
        .background(Color.backgroundApp.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear { manager = BackendManager(modelContext: modelContext) }
    }
    
    // MARK: - Components
    
    private var customNavigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .padding(12)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 5)
            }
            .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    func suggestionCard(_ activity: ActivityRecommendation) -> some View {
        let isSelected = selectedActivities.contains(activity)
        
        return Button {
            withAnimation(.spring(response: 0.3)) {
                if isSelected { selectedActivities.remove(activity) }
                else { selectedActivities.insert(activity) }
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.activity_name)
                        .font(.system(size: 17, weight: .medium))
                    Text(activity.category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? Color.primaryBrand : .gray.opacity(0.3))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.primaryBrand : Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Actions
    
    private func askAI() {
        Task {
            if let manager = manager {
                let result = await manager.getRecommendations(userStory: userStory)
                withAnimation {
                    self.recommendations = result
                    self.selectedActivities = []
                }
            }
        }
    }
    
    // PERBAIKAN: Logika menyimpan ke SwiftData DAN AppStorage
    private func saveSelection() {
        var currentSelected: Set<String> = []
        if let data = selectedActivitiesData.data(using: .utf8),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            currentSelected = decoded
        }
        
        for item in selectedActivities {
            // Simpan ke database SwiftData
            let activity = ActivityItem(name: item.activity_name, category: item.category)
            modelContext.insert(activity)
            
            // Tambahkan namanya ke daftar harian yang sedang aktif di Home
            currentSelected.insert(item.activity_name)
        }
        
        try? modelContext.save()
        
        if let encoded = try? JSONEncoder().encode(currentSelected) {
            selectedActivitiesData = String(data: encoded, encoding: .utf8) ?? ""
        }
        
        dismiss()
    }
}
