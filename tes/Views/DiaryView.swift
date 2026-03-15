import SwiftUI
import SwiftData

struct DiaryView: View {
    
    @State private var selectedDate: Date? = nil
    @State private var showWritePage = false
    
    @Query private var diaryEntries: [DiaryEntry]
    
    let calendar = Calendar.current
    let today = Date()
    
    // MARK: - Format Bulan & Tahun (Contoh: "Maret, 2026")
    var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "MMMM, yyyy"
        return formatter.string(from: today)
    }
    
    var body: some View {
        
        ZStack {
            
            // MARK: - KONTEN UTAMA (KALENDER)
            VStack(spacing: 24) {
                

                Text("Diary")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // MARK: - Label Bulan & Tahun
                Text(currentMonthYear)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                weekHeader
                
                calendarGrid
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // MARK: - OVERLAY TULIS DIARY
            if showWritePage, let date = selectedDate {
                WriteDiaryView(date: date, isPresented: $showWritePage)
                    .background(Color.backgroundApp)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: showWritePage)
    }
}

extension DiaryView {
    
    // MARK: - Week Header
    var weekHeader: some View {
        
        HStack {
            ForEach(["Min","Sen","Sel","Rab","Kam","Jum","Sab"], id:\.self) { day in
                Text(day)
                    .font(.system(size:14, weight:.semibold))
                    .foregroundColor(Color.textPrimary)
                    .frame(maxWidth:.infinity)
            }
        }
    }
    
    // MARK: - Calendar Grid
    var calendarGrid: some View {
        
        let days = generateDays()
        
        return LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 7),
            spacing: 18
        ) {
            ForEach(days, id:\.self) { day in
                calendarItem(day)
            }
        }
    }
    
    // MARK: - Calendar Item (Tanggal)
    func calendarItem(_ day: Int) -> some View {
        
        let todayDay = calendar.component(.day, from: today)
        let isToday = day == todayDay
        let isFuture = day > todayDay
        
        // Ambil tanggal spesifik untuk kotak ini
        let targetDate = dateFromDay(day)
        
        // CEK DATABASE: Adakah diary yang disimpan di tanggal ini?
        let entryForThisDay = diaryEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: targetDate)
        }
        
        return VStack(spacing: 6) {
            
            Button {
                if !isFuture {
                    selectedDate = targetDate
                    showWritePage = true
                }
            } label: {
                
                ZStack {
                    
                    // Lingkaran Dasar
                    Circle()
                        .fill(
                            isFuture ?
                            Color.gray.opacity(0.12) :
                            Color.primaryBrand.opacity(0.15)
                        )
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .stroke(
                                    isToday ? Color.primaryBrand : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    
                    // JIKA ADA DIARY: Tampilkan Gambar Mood
                    if let entry = entryForThisDay {
                        // Memanggil aset gambar berdasarkan mood yang tersimpan
                        Image(entry.mood)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 34, height: 34) // Sedikit lebih kecil dari lingkaran
                        
                    } else if !isFuture {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.primaryBrand)
                    }
                }
            }
            .disabled(isFuture)
            
            // Angka Tanggal (1, 2, 3...)
            Text("\(day)")
                .font(.caption)
                .foregroundColor(
                    isFuture ?
                    Color.gray.opacity(0.6) :
                    Color.gray
                )
        }
    }
}

extension DiaryView {
    
    // MARK: - Generate Days Logic
    func generateDays() -> [Int] {
        let range = calendar.range(
            of: .day,
            in: .month,
            for: Date()
        )!
        return Array(range)
    }
    
    func dateFromDay(_ day: Int) -> Date {
        let components = calendar.dateComponents(
            [.year, .month],
            from: Date()
        )
        
        return calendar.date(
            from: DateComponents(
                year: components.year,
                month: components.month,
                day: day
            )
        )!
    }
}

#Preview {
    DiaryView()
        .modelContainer(for: DiaryEntry.self, inMemory: true)
}
