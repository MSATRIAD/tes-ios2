import SwiftUI

struct HomeViews: View {
    
    let userName: String
    let selectedActivities: Set<String>
    
    @State private var completedActivities: Set<String> = []
    @State private var selectedFilter = "Semua"
    
    
    // MARK: Activity Category Mapping
    
    let activityCategory: [String: String] = [
        "Minum Air 2L": "Kesehatan",
        "Tidur 8 Jam": "Kesehatan",
        "Cek Kesehatan": "Kesehatan",
        
        "Olahraga 30 Menit": "Kebugaran",
        "Stretching Pagi": "Kebugaran",
        "Jalan 10.000 Langkah": "Kebugaran",
        
        "Membaca 10 Halaman": "Pengetahuan",
        "Belajar Skill Baru": "Pengetahuan",
        "Menonton Edukasi": "Pengetahuan",
        
        "Catat Pengeluaran": "Keuangan",
        "Menabung Harian": "Keuangan",
        "Belajar Investasi": "Keuangan",
        
        "Belajar Skill Karir": "Karir",
        "Update CV": "Karir",
        "Networking": "Karir",
        
        "Meditasi 10 Menit": "Mental",
        "Jurnal Harian": "Mental",
        "Digital Detox": "Mental"
    ]
    
    
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
    }
}

extension HomeViews {
    
    // MARK: Greeting
    
    var greeting: some View {
        
        Text("Hi, \(userName)")
            .font(.system(size:34, weight:.bold))
            .foregroundColor(Color.textPrimary)
    }
    
    
    // MARK: Week Tracker
    
    var weekTracker: some View {
        
        VStack(spacing:12) {
            
            HStack {
                day("Sen")
                day("Sel")
                day("Rab")
                day("Kam", selected:true)
                day("Jum")
                day("Sab")
                day("Min")
            }
            
            HStack {
                date("30")
                date("31")
                date("32")
                date("33", active:true)
                date("34")
                date("35")
                date("36")
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
    
    
    func date(_ text:String, active:Bool = false) -> some View {
        
        Text(text)
            .font(.system(size:18, weight:.bold))
            .foregroundColor(active ? .white : Color.textPrimary)
            .frame(width:40,height:40)
            .background(
                active ?
                Color.primaryBrand :
                Color.iconBackground
            )
            .clipShape(Circle())
            .frame(maxWidth:.infinity)
    }
    
    
    // MARK: Progress Card
    
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
        
        return Double(completedActivities.count) /
        Double(selectedActivities.count)
    }
    
    
    // MARK: Filtered Activities
    
    var filteredActivities: [String] {
        
        if selectedFilter == "Semua" {
            return Array(selectedActivities)
        }
        
        return selectedActivities.filter {
            activityCategory[$0] == selectedFilter
        }
    }
    
    
    // MARK: Habit Section
    
    var habitSection: some View {
        
        VStack(alignment:.leading, spacing:16) {
            
            HStack {
                
                Text("Aktivitas Hari Ini")
                    .font(.system(size:22, weight:.bold))
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                filterMenu
                
            }
            
            VStack(spacing:12) {
                
                ForEach(filteredActivities, id:\.self) { activity in
                    
                    habitRow(activity)
                    
                }
            }
        }
    }
    
    
    // MARK: Improved Filter Menu
    
    var filterMenu: some View {
        
        Menu {
            
            filterItem("Semua")
            filterItem("Kesehatan")
            filterItem("Kebugaran")
            filterItem("Pengetahuan")
            filterItem("Keuangan")
            filterItem("Karir")
            filterItem("Mental")
            
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
            .background(
                Capsule()
                    .fill(Color.primaryBrand.opacity(0.15))
            )
            .overlay(
                Capsule()
                    .stroke(Color.primaryBrand.opacity(0.35), lineWidth:1)
            )
        }
    }
    
    
    func filterItem(_ category:String) -> some View {
        
        Button {
            
            withAnimation(.easeInOut(duration:0.2)) {
                selectedFilter = category
            }
            
        } label: {
            
            if selectedFilter == category {
                
                Label(category, systemImage:"checkmark")
                
            } else {
                
                Text(category)
            }
        }
    }
    
    
    // MARK: Habit Row
    
    func habitRow(_ activity:String) -> some View {
        
        let completed = completedActivities.contains(activity)
        
        return HStack {
            
            Image(systemName:
                    completed ?
                  "checkmark.circle.fill" :
                  "circle")
                .foregroundColor(
                    completed ?
                    Color.green :
                    Color.gray
                )
                .font(.title3)
            
            Text(activity)
                .font(.system(size:16, weight:.medium))
            
            Spacer()
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(14)
        .shadow(color:.black.opacity(0.03), radius:6)
        .onTapGesture {
            
            if completed {
                completedActivities.remove(activity)
            } else {
                completedActivities.insert(activity)
            }
        }
    }
}

#Preview {
    
    HomeViews(
        userName:"Iyan",
        selectedActivities:[
            "Minum Air 2L",
            "Olahraga 30 Menit",
            "Membaca 10 Halaman"
        ]
    )
}
