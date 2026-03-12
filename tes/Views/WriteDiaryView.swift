import SwiftUI

struct WriteDiaryView: View {
    
    let date: Date
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var text: String = ""
    @State private var selectedMood: Mood? = nil
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            moodSection
            
            dateHeader
            
            diaryEditor
            
            Spacer()
        }
        .padding(.horizontal,20)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            // BACK BUTTON
            
            ToolbarItem(placement: .topBarLeading) {
                
                Button {
                    dismiss()
                } label: {
                    
                    HStack(spacing:4) {
                        Image(systemName: "chevron.left")
                        Text("Kembali")
                    }
                }
                .foregroundColor(Color.textPrimary)
            }
            
            
            // SAVE BUTTON
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Button {
                    saveDiary()
                } label: {
                    Text("Simpan")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color.primaryBrand)
                .disabled(text.isEmpty)
            }
        }
    }
}

extension WriteDiaryView {
    
    // SAVE DIARY
    
    func saveDiary() {
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        print("Diary saved")
        print("Tanggal:", formattedDate)
        print("Mood:", selectedMood?.title ?? "-")
        print("Text:", text)
        
        dismiss()
    }
}

extension WriteDiaryView {
    
    // MOOD
    
    var moodSection: some View {
        
        VStack(spacing: 16) {
            
            Text("Bagaimana perasaan kamu hari ini?")
                .font(.system(size:18, weight:.semibold))
                .foregroundColor(Color.textPrimary)
            
            HStack(spacing: 24) {
                
                moodButton(.happy)
                moodButton(.scared)
                moodButton(.angry)
                moodButton(.sad)
            }
        }
        .padding()
        .background(Color.primaryBrand.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius:16)
                .stroke(Color.primaryBrand, lineWidth:1)
        )
        .cornerRadius(16)
    }
    
    
    func moodButton(_ mood: Mood) -> some View {
        
        VStack(spacing:6) {
            
            Image(mood.imageName)
                .resizable()
                .scaledToFit()
                .frame(width:56,height:56)
                .scaleEffect(selectedMood == mood ? 1.15 : 1)
                .animation(.spring(response:0.3), value: selectedMood)
            
            Text(mood.title)
                .font(.caption)
                .foregroundColor(Color.textPrimary)
        }
        .onTapGesture {
            selectedMood = mood
        }
    }
}

extension WriteDiaryView {
    
    // DATE HEADER
    
    var dateHeader: some View {
        
        HStack {
            
            Text(dayName)
                .font(.system(size:16, weight:.medium))
                .foregroundColor(Color.textSecondary)
            
            Spacer()
            
            Text(formattedDate)
                .font(.system(size:16, weight:.semibold))
                .foregroundColor(Color.textPrimary)
        }
    }
}

extension WriteDiaryView {
    
    // DIARY EDITOR
    
    var diaryEditor: some View {
        
        ZStack(alignment: .topLeading) {
            
            RoundedRectangle(cornerRadius:16)
                .stroke(Color.primaryBrand, lineWidth:2)
                .background(Color.cardBackground)
                .cornerRadius(16)
            
            if text.isEmpty {
                
                Text("Tulis apapun yang ingin kamu sampaikan terkait hari ini...")
                    .foregroundColor(Color.textSecondary)
                    .padding()
            }
            
            TextEditor(text: $text)
                .padding(12)
                .font(.system(size:16))
                .background(Color.clear)
        }
        .frame(height:300)
    }
}

extension WriteDiaryView {
    
    // DATE FORMAT
    
    var formattedDate: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "id_ID")
        
        return formatter.string(from: date)
    }
    
    
    var dayName: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "id_ID")
        
        return formatter.string(from: date)
    }
}

enum Mood: CaseIterable {
    
    case happy
    case scared
    case angry
    case sad
    
    var title: String {
        
        switch self {
        case .happy: return "Bahagia"
        case .scared: return "Takut"
        case .angry: return "Marah"
        case .sad: return "Sedih"
        }
    }
    
    var imageName: String {
        
        switch self {
        case .happy: return "Bahagia"
        case .scared: return "Takut"
        case .angry: return "Marah"
        case .sad: return "Sedih"
        }
    }
}

#Preview {
    NavigationStack {
        WriteDiaryView(date: Date())
    }
}
