import SwiftUI
import SwiftData

struct CategorySelectionView: View {
    
    let userName: String
    var isFromProfile: Bool = false
    @Binding var isPresented: Bool
    
    @Environment(\.modelContext) private var modelContext
    @Query private var allActivityItems: [ActivityItem]
    
    var categories: [String] {
        let fetchedCategories = allActivityItems.map { $0.category }
        return Array(Set(fetchedCategories)).sorted()
    }
    
    @State private var selectedCategories: Set<String> = []
    @State private var navigateToActivities = false
    
    init(userName: String, isFromProfile: Bool = false, isPresented: Binding<Bool> = .constant(true)) {
        self.userName = userName
        self.isFromProfile = isFromProfile
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    categoryList
                }
                .padding(24)
            }
            continueButton
        }
        .background(Color.backgroundApp)
        .toolbar {
            if isFromProfile {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Batal") {
                        isPresented = false
                    }
                    .foregroundColor(Color.primaryBrand)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToActivities) {
            ActivityRecommendationView(
                selectedCategories: selectedCategories,
                userName: userName,
                isFromProfile: isFromProfile,
                isPresented: $isPresented
            )
        }
    }
}

extension CategorySelectionView {
    
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Apa yang ingin kamu tingkatkan?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.textPrimary)
                .fixedSize(horizontal:false, vertical:true)
            
            Text("Pilih hingga 3 kategori yang paling penting untukmu saat ini.")
                .font(.subheadline)
                .foregroundColor(Color.textSecondary)
                .fixedSize(horizontal:false, vertical:true)
            
            Text("\(selectedCategories.count)/3 dipilih")
                .font(.caption)
                .foregroundColor(Color.textSecondary)
        }
    }
    
    var categoryList: some View {
        VStack(spacing: 14) {
            ForEach(categories, id: \.self) { category in
                categoryCard(category)
            }
        }
    }
    
    var continueButton: some View {
        Button {
            UIImpactFeedbackGenerator(style:.medium).impactOccurred()
            navigateToActivities = true
        } label: {
            Text("Pilih Aktivitas (\(selectedCategories.count))")
                .font(.system(size:17, weight:.semibold))
                .frame(maxWidth:.infinity)
                .padding()
                .background(
                    selectedCategories.isEmpty ?
                    Color.gray.opacity(0.2) :
                    Color.primaryBrand
                )
                .foregroundColor(.white)
                .cornerRadius(14)
        }
        .disabled(selectedCategories.isEmpty)
        .padding(24)
    }
}

extension CategorySelectionView {
    
    func categoryCard(_ category:String) -> some View {
        let isSelected = selectedCategories.contains(category)
        
        return HStack(spacing: 16) {
            Image(systemName: iconFor(category))
                .font(.system(size:18))
                .foregroundColor(isSelected ? .white : Color.primaryBrand)
                .frame(width:42,height:42)
                .background(isSelected ? Color.primaryBrand : Color.iconBackground)
                .cornerRadius(12)
            
            Text(category)
                .font(.system(size:18, weight:.medium))
                .foregroundColor(Color.textPrimary)
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? Color.primaryBrand : Color.gray.opacity(0.4))
        }
        .padding()
        .background(isSelected ? Color.iconBackground.opacity(0.6) : Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius:16)
                .stroke(isSelected ? Color.primaryBrand : Color.clear, lineWidth:1.5)
        )
        .shadow(color:Color.black.opacity(0.03), radius:6, x:0, y:3)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response:0.25, dampingFraction:0.8)) {
                toggleCategory(category)
                UIImpactFeedbackGenerator(style:.light).impactOccurred()
            }
        }
    }
    
    func toggleCategory(_ category:String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            if selectedCategories.count < 3 {
                selectedCategories.insert(category)
            }
        }
    }
    
    func iconFor(_ category:String) -> String {
        switch category {
        case "Kesehatan": return "waveform.path.ecg"
        case "Kebugaran": return "dumbbell.fill"
        case "Pengetahuan": return "book.fill"
        default: return "circle"
        }
    }
}
