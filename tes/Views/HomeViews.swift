import SwiftUI

struct HomeViews: View {
    
    let selectedActivities: Set<String>
    
    @State private var completedActivities: Set<String> = []
    @State private var note: String = ""
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    greeting
                    
                    weekTracker
                    
                    progressCard
                    
                    todayHabits
                    
                    quickNotes
                    
                }
                .padding(24)
            }
            
            bottomTabBar
            
        }
        .background(Color(hex:"#F8FAFC"))
    }
}

extension HomeViews {
    
    // MARK: Greeting
    
    var greeting: some View {
        
        Text("Hi, Iyan 👋")
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(Color(hex:"#3A2E1F"))
    }
    
    
    // MARK: Week Tracker
    
    var weekTracker: some View {
        
        VStack(spacing:10) {
            
            HStack {
                weekDay("Sen")
                weekDay("Sel")
                weekDay("Rab")
                weekDay("Kam", selected:true)
                weekDay("Jum")
                weekDay("Sab")
                weekDay("Min")
            }
            
            HStack {
                weekNumber("30")
                weekNumber("31")
                weekNumber("32")
                weekNumber("33", active:true)
                weekNumber("34")
                weekNumber("35")
                weekNumber("36")
            }
        }
    }
    
    
    func weekDay(_ text:String, selected:Bool = false) -> some View {
        
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(selected ? .black : .gray)
            .frame(maxWidth:.infinity)
    }
    
    
    func weekNumber(_ text:String, active:Bool = false) -> some View {
        
        Text(text)
            .font(.system(size:18, weight:.bold))
            .foregroundColor(active ? .white : Color(hex:"#6E5B3D"))
            .frame(width:40,height:40)
            .background(
                active ?
                Color(hex:"#B08A00") :
                Color(hex:"#E9E3D4")
            )
            .clipShape(Circle())
            .frame(maxWidth:.infinity)
    }
    
    
    // MARK: Progress Card
    
    var progressCard: some View {
        
        VStack(alignment:.leading, spacing:12) {
            
            Text("Progres Hari ini")
                .font(.system(size:18, weight:.bold))
                .foregroundColor(.white)
            
            ProgressView(value: progress)
                .tint(.white)
            
            HStack {
                
                Text("\(completedActivities.count)/\(selectedActivities.count) Kegiatan")
                    .font(.caption)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color(hex:"#F2B705"))
        .cornerRadius(18)
        .shadow(color:.black.opacity(0.1), radius:8)
    }
    
    
    var progress: Double {
        
        if selectedActivities.isEmpty { return 0 }
        
        return Double(completedActivities.count) /
        Double(selectedActivities.count)
    }
    
    
    // MARK: Today's Habits
    
    var todayHabits: some View {
        
        VStack(alignment:.leading, spacing:12) {
            
            Text("Today's Habits")
                .font(.system(size:22, weight:.bold))
                .foregroundColor(Color(hex:"#5B3B5B"))
            
            ForEach(Array(selectedActivities), id:\.self) { activity in
                
                habitRow(activity)
                
            }
        }
    }
    
    
    func habitRow(_ activity:String) -> some View {
        
        let completed = completedActivities.contains(activity)
        
        return HStack {
            
            Image(systemName:
                    completed ?
                  "checkmark.circle.fill" :
                  "circle")
                .font(.title3)
                .foregroundColor(
                    completed ?
                    Color.green :
                    Color.gray
                )
            
            Text(activity)
                .font(.system(size:16, weight:.medium))
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color:.black.opacity(0.03), radius:5)
        .onTapGesture {
            
            if completed {
                completedActivities.remove(activity)
            } else {
                completedActivities.insert(activity)
            }
        }
    }
    
    
    // MARK: Quick Notes
    
    var quickNotes: some View {
        
        VStack(alignment:.leading, spacing:12) {
            
            Text("Quick Notes")
                .font(.system(size:22, weight:.bold))
                .foregroundColor(Color(hex:"#5B3B5B"))
            
            TextEditor(text: $note)
                .frame(height:120)
                .padding()
                .background(Color(hex:"#5B3B5B"))
                .cornerRadius(16)
                .foregroundColor(.white)
        }
    }
    
    
    // MARK: Bottom Tab Bar
    
    var bottomTabBar: some View {
        
        HStack {
            
            tabItem("checkmark.circle","Habit", active:true)
            
            Spacer()
            
            tabItem("chart.bar","Progress")
            
            Spacer()
            
            tabItem("book","Diary")
            
            Spacer()
            
            tabItem("person","Profile")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius:30)
                .fill(Color.gray.opacity(0.3))
        )
        .padding()
    }
    
    
    func tabItem(
        _ icon:String,
        _ title:String,
        active:Bool = false
    ) -> some View {
        
        VStack {
            
            Image(systemName: icon)
                .font(.title3)
            
            Text(title)
                .font(.caption)
        }
        .foregroundColor(active ? Color.green : .white)
    }
}

#Preview {
    HomeViews(selectedActivities:[
        "Minum Air 2L",
        "Olahraga 30 Menit",
        "Membaca 10 Halaman"
    ])
}
