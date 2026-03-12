import SwiftUI
import UIKit

struct CategorySelectionView: View {
    
    // MARK: Data
    
    let categories = [
        "Kesehatan",
        "Kebugaran",
        "Pengetahuan",
        "Keuangan",
        "Karir",
        "Mental"
    ]
    
    // MARK: State
    
    @State private var selectedCategories: Set<String> = []
    @State private var navigateToActivities = false
    
    
    var body: some View {
        
        NavigationStack {
            
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
            
            .navigationDestination(isPresented: $navigateToActivities) {
                
                ActivityRecommendationView(
                    selectedCategories: selectedCategories
                )
            }
        }
    }
}

extension CategorySelectionView {
    
    // MARK: Header
    
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
    
    
    // MARK: Category List
    
    var categoryList: some View {
        
        VStack(spacing: 14) {
            
            ForEach(categories, id: \.self) { category in
                
                categoryCard(category)
                
            }
        }
    }
    
    
    // MARK: Continue Button
    
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
    
    
    // MARK: Category Card
    
    func categoryCard(_ category:String) -> some View {
        
        let isSelected = selectedCategories.contains(category)
        
        return HStack(spacing: 16) {
            
            Image(systemName: iconFor(category))
                .font(.system(size:18))
                .foregroundColor(isSelected ? .white : Color.primaryBrand)
                .frame(width:42,height:42)
                .background(
                    isSelected ?
                    Color.primaryBrand :
                    Color.iconBackground
                )
                .cornerRadius(12)
            
            
            Text(category)
                .font(.system(size:18, weight:.medium))
                .foregroundColor(Color.textPrimary)
            
            
            Spacer()
            
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(
                    isSelected ?
                    Color.primaryBrand :
                    Color.gray.opacity(0.4)
                )
        }
        .padding()
        .background(isSelected ? Color.iconBackground.opacity(0.6) : Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius:16)
                .stroke(isSelected ? Color.primaryBrand : Color.clear, lineWidth:1.5)
        )
        .shadow(color:Color.black.opacity(0.03), radius:6, x:0, y:3)
        .onTapGesture {
            
            withAnimation(.spring(response:0.25, dampingFraction:0.8)) {
                
                toggleCategory(category)
                
                UIImpactFeedbackGenerator(style:.light).impactOccurred()
            }
        }
    }
    
    
    // MARK: Toggle Category
    
    func toggleCategory(_ category:String) {
        
        if selectedCategories.contains(category) {
            
            selectedCategories.remove(category)
            
        } else {
            
            if selectedCategories.count < 3 {
                
                selectedCategories.insert(category)
            }
        }
    }
    
    
    // MARK: Icons
    
    func iconFor(_ category:String) -> String {
        
        switch category {
            
        case "Kesehatan":
            return "waveform.path.ecg"
            
        case "Kebugaran":
            return "dumbbell.fill"
            
        case "Pengetahuan":
            return "book.fill"
            
        case "Keuangan":
            return "dollarsign"
            
        case "Karir":
            return "briefcase.fill"
            
        case "Mental":
            return "brain.head.profile"
            
        default:
            return "circle"
        }
    }
}

#Preview {
    CategorySelectionView()
}
