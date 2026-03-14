import SwiftUI
import SwiftData

// MARK: - Model Database untuk Diary
@Model
class DiaryEntry {
    var id: UUID = UUID()
    var date: Date
    var text: String
    var mood: String
    
    init(date: Date, text: String, mood: String) {
        self.date = date
        self.text = text
        self.mood = mood
    }
}

struct WriteDiaryView: View {
    
    let date: Date
    
    // Penampung status untuk kembali ke halaman sebelumnya
    @Binding var isPresented: Bool
    
    // Akses ke database
    @Environment(\.modelContext) private var modelContext
    @Query private var diaryEntries: [DiaryEntry]
    
    @State private var text: String = ""
    @State private var selectedMood: Mood? = nil
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            // TOMBOL KEMBALI
            HStack {
                Button {
                    isPresented = false
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Kembali")
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                }
                Spacer()
            }
            .padding(.top, 10)
            
            // 1. Kotak Perasaan (Mood)
            moodSection
            
            VStack(alignment: .leading, spacing: 12) {
                // 2. Tanggal
                dateHeader
                
                // 3. Kotak Teks (Editor)
                diaryEditor
            }
            
            Spacer()
            
            // 4. Tombol Simpan di bawah
            saveButton
            
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
        .navigationBarHidden(true) // Sembunyikan navigasi bawaan
        .onAppear {
            loadExistingDiary()
        }
    }
}

extension WriteDiaryView {
    
    // MARK: - LOAD DIARY LOGIC
    func loadExistingDiary() {
        let calendar = Calendar.current
        // Cek apakah sudah ada diary di tanggal yang dipilih
        if let existingEntry = diaryEntries.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            self.text = existingEntry.text
            self.selectedMood = Mood.allCases.first(where: { $0.title == existingEntry.mood })
        }
    }
    
    // MARK: - SAVE DIARY LOGIC
    func saveDiary() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        guard let mood = selectedMood else { return }
        
        let calendar = Calendar.current
        
        // Update data jika sudah ada, atau buat baru jika belum ada
        if let existingEntry = diaryEntries.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            existingEntry.text = text
            existingEntry.mood = mood.title
        } else {
            let newEntry = DiaryEntry(date: date, text: text, mood: mood.title)
            modelContext.insert(newEntry)
        }
        
        try? modelContext.save()
        print("✅ Diary berhasil disimpan!")
        
        // Tutup halaman setelah simpan
        isPresented = false
    }
}

extension WriteDiaryView {
    
    // MARK: - MOOD SECTION
    var moodSection: some View {
        
        VStack(spacing: 16) {
            
            Text("Bagaimana perasaan kamu hari ini?")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.textPrimary)
            
            HStack(spacing: 24) {
                moodButton(.happy)
                moodButton(.scared)
                moodButton(.angry)
                moodButton(.sad)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(Color.primaryBrand.opacity(0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primaryBrand, lineWidth: 1.5)
        )
        .cornerRadius(16)
    }
    
    func moodButton(_ mood: Mood) -> some View {
        
        VStack(spacing: 8) {
            
            Image(mood.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .scaleEffect(selectedMood == mood ? 1.15 : 1)
                .animation(.spring(response: 0.3), value: selectedMood)
            
            Text(mood.title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.textPrimary)
        }
        .onTapGesture {
            selectedMood = mood
        }
    }
}

extension WriteDiaryView {
    
    // MARK: - DATE HEADER
    var dateHeader: some View {
        Text("\(dayName), \(formattedDate)")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(Color.textPrimary)
    }
}

extension WriteDiaryView {
    
    // MARK: - DIARY EDITOR
    var diaryEditor: some View {
        
        ZStack(alignment: .topLeading) {
            
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primaryBrand, lineWidth: 2)
                .background(Color.cardBackground)
                .cornerRadius(16)
            
            if text.isEmpty {
                Text("Tulis apapun yang ingin kamu sampaikan terkait hari ini...")
                    .font(.system(size: 15))
                    .foregroundColor(Color.gray.opacity(0.8))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
            }
            
            TextEditor(text: $text)
                .font(.system(size: 15))
                .foregroundColor(Color.textPrimary)
                .padding(12)
                .background(Color.clear)
                .scrollContentBackground(.hidden)
        }
        .frame(maxHeight: .infinity)
    }
}

extension WriteDiaryView {
    
    // MARK: - SAVE BUTTON
    var saveButton: some View {

        let isFormComplete = !text.isEmpty && selectedMood != nil
        
        return Button {
            saveDiary()
        } label: {
            Text("Simpan")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    isFormComplete ? Color.primaryBrand : Color.gray.opacity(0.3)
                )
                .foregroundColor(.white)
                .cornerRadius(16)
        }
        .disabled(!isFormComplete) // Disable jika form belum lengkap
        .padding(.bottom, 8)
    }
}

extension WriteDiaryView {
    
    // MARK: - DATE FORMAT LOGIC
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
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
    case happy, scared, angry, sad
    
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

// Dummy Wrapper untuk Preview agar isPresented tetap bisa bekerja di Preview
struct WriteDiaryView_PreviewWrapper: View {
    @State private var dummyPresented = true
    var body: some View {
        WriteDiaryView(date: Date(), isPresented: $dummyPresented)
            .modelContainer(for: DiaryEntry.self, inMemory: true)
    }
}

#Preview {
    WriteDiaryView_PreviewWrapper()
}
