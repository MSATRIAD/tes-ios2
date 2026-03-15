import SwiftUI
import Charts
import SwiftData

struct ProgressViewPage: View {
    
    struct TaskData: Identifiable {
        let id = UUID()
        let date: String
        let value: Int
    }
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var allCompletedTasks: [CompletedTask]
    
    // KUNCI PERBAIKAN 1: Jadikan "Semua" sebagai default dan tambahkan ke array
    @State private var selectedCategory = "Semua"
    @State private var selectedTimeframe = "Mingguan"
    
    let categories = ["Semua", "Kesehatan", "Kebugaran", "Pengetahuan"]
    let timeframes = ["Mingguan", "Bulanan"]
    
    @AppStorage("selectedActivitiesData") var selectedActivitiesData: String = ""
    
    var selectedActivities: Set<String> {
        guard let data = selectedActivitiesData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            return []
        }
        return decoded
    }
    
    var dynamicChartData: [TaskData] {
        let daysCount = selectedTimeframe == "Mingguan" ? 7 : 30
        let dates = generatePastDates(days: daysCount)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "id_ID")
        
        return dates.map { date in
            let dateString = formatter.string(from: date)
            let count = fetchCompletedTasks(for: date, category: selectedCategory)
            
            return TaskData(date: dateString, value: count)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Filter Menu
            HStack {
                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedCategory = category
                            }
                        } label: {
                            if selectedCategory == category {
                                Label(category, systemImage: "checkmark")
                            } else {
                                Text(category)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedCategory)
                            .font(.system(size: 14, weight: .semibold))
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(Color.primaryBrand)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.primaryBrand.opacity(0.15)))
                    .overlay(Capsule().stroke(Color.primaryBrand.opacity(0.35), lineWidth: 1))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // KUNCI PERBAIKAN 2: Teks dinamis agar tata bahasanya pas saat memilih "Semua"
            if selectedCategory == "Semua" {
                Text("Rutinitasmu secara keseluruhan terpantau dengan baik!")
                    .font(.body)
                    .foregroundColor(Color.textPrimary)
                    .padding(.horizontal, 16)
            } else {
                Text("Rutinitasmu di kategori \(selectedCategory.lowercased()) terpantau dengan baik!")
                    .font(.body)
                    .foregroundColor(Color.textPrimary)
                    .padding(.horizontal, 16)
            }
            
            // MARK: - Rentang Waktu
            Picker("Rentang Waktu", selection: $selectedTimeframe) {
                ForEach(timeframes, id: \.self) { time in
                    Text(time).tag(time)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            
            // MARK: - CHART (Live Data)
            ZStack {
                Chart(dynamicChartData) { item in
                    LineMark(
                        x: .value("Tanggal", item.date),
                        y: .value("Selesai", item.value)
                    )
                    .symbol(Circle())
                    .foregroundStyle(Color.primaryBrand)
                }
                .chartXAxis {
                    if selectedTimeframe == "Bulanan" {
                        AxisMarks(values: .stride(by: 5))
                    } else {
                        AxisMarks()
                    }
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.cardBackground))
            }
            .frame(height: 300)
            .padding(.horizontal, 16)
            .animation(.spring(), value: dynamicChartData.map { $0.value })
            .animation(.easeInOut, value: selectedCategory)
            .animation(.easeInOut, value: selectedTimeframe)
            
            Spacer()
        }
        .padding(.top, 20)
        .background(Color.backgroundApp)
    }
}

// MARK: - Backend Logic
extension ProgressViewPage {
    
    private func generatePastDates(days: Int) -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var dates: [Date] = []
        
        for i in (0..<days).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                dates.append(date)
            }
        }
        return dates
    }
    
    private func fetchCompletedTasks(for date: Date, category: String) -> Int {
        let calendar = Calendar.current
        
        let count = allCompletedTasks.filter { task in
            // Pastikan tanggal sama dan aktivitas tersebut sedang aktif dipilih user
            let isSameDate = calendar.isDate(task.date, inSameDayAs: date)
            let isActivitySelected = selectedActivities.contains(task.activityName)
            
            // KUNCI PERBAIKAN 3: Lewati pengecekan nama kategori jika "Semua" yang dipilih
            if category == "Semua" {
                return isSameDate && isActivitySelected
            } else {
                return isSameDate && isActivitySelected && task.category == category
            }
        }.count
        
        return count
    }
}

#Preview {
    ProgressViewPage()
}
