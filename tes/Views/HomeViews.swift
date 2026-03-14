import SwiftUI
import SwiftData

struct HomeViews: View {
    
    @AppStorage("userName") var userName: String = "User"
    
    @AppStorage("selectedActivitiesData") var selectedActivitiesData: String = ""
    
    // Computed property untuk mengubah memori String -> Set<String>
    var selectedActivities: Set<String> {
        guard let data = selectedActivitiesData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            return []
        }
        return decoded
    }
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var allCompletedTasks: [CompletedTask]
    @Query private var allActivityItems: [ActivityItem]
    
    @State private var selectedFilter = "Semua"
    
    // MARK: - Dynamic Activity Mapping
    var activityCategoryMap: [String: String] {
        var map: [String: String] = [:]
        for item in allActivityItems {
            map[item.name] = item.category
        }
        return map
    }
    
    // MARK: - Dynamic Categories for Filter
    var availableCategories: [String] {
        let activeCategories = selectedActivities.compactMap { activityCategoryMap[$0] }
        return Array(Set(activeCategories)).sorted()
    }
    
    // MARK: - Completed Activities Today
    var completedActivities: Set<String> {
        let calendar = Calendar.current
        let today = Date()
        
        let todayTasks = allCompletedTasks.filter { task in
            calendar.isDate(task.date, inSameDayAs: today) &&
            selectedActivities.contains(task.activityName)
        }
        
        return Set(todayTasks.map { $0.activityName })
    }
    
    var body: some View {
        VStack(spacing:0) {
            ScrollView {
                VStack(alignment:.leading, spacing:28) {
                    greeting
                    weekTracker
                    progressCard
                    habitSection
                }
                .padding(24)
            }
        }
        .background(Color.backgroundApp)
        .navigationBarBackButtonHidden(true)
    }
}

extension HomeViews {
    
    // MARK: - Greeting
    var greeting: some View {
        Text("Hi, \(userName)")
            .font(.system(size:34, weight:.bold))
            .foregroundColor(Color.textPrimary)
    }
    
    // MARK: - Week Tracker
    var weekTracker: some View {
        let dates = currentWeekDates
        let calendar = Calendar.current
        let today = Date()
        
        return VStack(spacing:12) {
            HStack {
                ForEach(dates, id: \.self) { date in
                    let isToday = calendar.isDate(date, inSameDayAs: today)
                    day(shortDayName(from: date), selected: isToday)
                }
            }
            HStack {
                ForEach(dates, id: \.self) { date in
                    let isToday = calendar.isDate(date, inSameDayAs: today)
                    let dayNumber = String(calendar.component(.day, from: date))
                    dateCircle(dayNumber, active: isToday)
                }
            }
        }
    }
    
    func day(_ text:String, selected:Bool = false) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(selected ? .black : .gray)
            .frame(maxWidth:.infinity)
    }
    

    func dateCircle(_ text:String, active:Bool = false) -> some View {
        Text(text)
            .font(.system(size:18, weight:.bold))
            .foregroundColor(active ? .white : Color.textPrimary)
            .frame(width:40,height:40)
            .background(active ? Color.primaryBrand : Color.iconBackground)
            .clipShape(Circle())
            .frame(maxWidth:.infinity)
    }
    
    var currentWeekDates: [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let today = Date()
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return []
        }
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    func shortDayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    // MARK: - Progress Card
    var progressCard: some View {
        VStack(alignment:.leading, spacing:12) {
            Text("Progres Hari Ini")
                .font(.system(size:18, weight:.bold))
                .foregroundColor(.white)
            ProgressView(value:progress)
                .tint(.white)
            HStack {
                Text("\(completedActivities.count)/\(selectedActivities.count) Kegiatan")
                    .font(.caption)
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(progress*100))%")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.primaryBrand)
        .cornerRadius(18)
        .shadow(color:.black.opacity(0.08), radius:10)
    }
    
    var progress: Double {
        if selectedActivities.isEmpty { return 0 }
        return Double(completedActivities.count) / Double(selectedActivities.count)
    }
    
    // MARK: - Filter Logic
    var filteredActivities: [String] {
        if selectedFilter == "Semua" { return Array(selectedActivities) }
        return selectedActivities.filter { activityCategoryMap[$0] == selectedFilter }
    }
    
    // MARK: - Habit Section List
    var habitSection: some View {
        VStack(alignment:.leading, spacing:16) {
            HStack {
                Text("Aktivitas Hari Ini")
                    .font(.system(size:22, weight:.bold))
                    .foregroundColor(Color.textPrimary)
                Spacer()
                filterMenu
            }
            
            if filteredActivities.isEmpty {
                Text("Belum ada aktivitas yang dipilih.")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            } else {
                VStack(spacing:12) {
                    ForEach(filteredActivities.sorted(), id:\.self) { activity in
                        habitRow(activity)
                    }
                }
            }
        }
    }
    
    // MARK: - Filter Menu
    var filterMenu: some View {
        Menu {
            filterItem("Semua")
            ForEach(availableCategories, id: \.self) { category in
                filterItem(category)
            }
        } label: {
            HStack(spacing:6) {
                Text(selectedFilter)
                    .font(.system(size:14, weight:.semibold))
                    .lineLimit(1)
                Image(systemName:"chevron.down")
                    .font(.system(size:12, weight:.bold))
            }
            .foregroundColor(Color.primaryBrand)
            .padding(.horizontal,14)
            .padding(.vertical,8)
            .background(Capsule().fill(Color.primaryBrand.opacity(0.15)))
            .overlay(Capsule().stroke(Color.primaryBrand.opacity(0.35), lineWidth:1))
        }
    }
    
    func filterItem(_ category:String) -> some View {
        Button {
            withAnimation(.easeInOut(duration:0.2)) { selectedFilter = category }
        } label: {
            if selectedFilter == category { Label(category, systemImage:"checkmark") }
            else { Text(category) }
        }
    }
    
    // MARK: - Habit Row
    func habitRow(_ activity:String) -> some View {
        let completed = completedActivities.contains(activity)
        
        return Button {
            let calendar = Calendar.current
            let today = Date()
            
            withAnimation(.spring()) {
                if completed {
                    if let taskToDelete = allCompletedTasks.first(where: {
                        $0.activityName == activity && calendar.isDate($0.date, inSameDayAs: today)
                    }) {
                        modelContext.delete(taskToDelete)
                    }
                } else {
                    // Cari kategori dari database, jika tidak ada, default "Lainnya"
                    let category = activityCategoryMap[activity] ?? "Lainnya"
                    let newTask = CompletedTask(activityName: activity, category: category, date: today)
                    modelContext.insert(newTask)
                }
                try? modelContext.save()
            }
        } label: {
            HStack {
                Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(completed ? Color.green : Color.gray)
                    .font(.title3)
                
                Text(activity)
                    .font(.system(size:16, weight:.medium))
                    .foregroundColor(Color.textPrimary)
                Spacer()
            }
            .padding()
            .contentShape(Rectangle())
            .background(Color.cardBackground)
            .cornerRadius(14)
            .shadow(color:.black.opacity(0.03), radius:6)
        }
        .buttonStyle(.plain)
    }
}
