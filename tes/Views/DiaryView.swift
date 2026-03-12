import SwiftUI

struct DiaryView: View {
    
    @State private var selectedDate: Date? = nil
    @State private var showWritePage = false
    
    let calendar = Calendar.current
    let today = Date()
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 24) {
                
                Text("Diary")
                    .font(.system(size:28, weight:.bold))
                    .foregroundColor(Color.textPrimary)
                
                weekHeader
                
                calendarGrid
                
                Spacer()
            }
            .padding(.horizontal,20)
            .navigationDestination(isPresented: $showWritePage) {
                
                if let date = selectedDate {
                    WriteDiaryView(date: date)
                }
            }
        }
    }
}

extension DiaryView {
    
    // MARK: Week Header
    
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
    
    
    // MARK: Calendar Grid
    
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
    
    
    // MARK: Calendar Item
    
    func calendarItem(_ day:Int) -> some View {
        
        let todayDay = calendar.component(.day, from: today)
        let isToday = day == todayDay
        let isFuture = day > todayDay
        
        return VStack(spacing:6) {
            
            Button {
                
                if !isFuture {
                    selectedDate = dateFromDay(day)
                    showWritePage = true
                }
                
            } label: {
                
                ZStack {
                    
                    Circle()
                        .fill(
                            isFuture ?
                            Color.gray.opacity(0.12) :
                            Color.primaryBrand.opacity(0.15)
                        )
                        .frame(width:48,height:48)
                        .overlay(
                            Circle()
                                .stroke(
                                    isToday ?
                                    Color.primaryBrand :
                                    Color.clear,
                                    lineWidth:2
                                )
                        )
                    
                    if !isFuture {
                        
                        Image(systemName:"plus")
                            .font(.system(size:18, weight:.bold))
                            .foregroundColor(Color.primaryBrand)
                    }
                }
            }
            .disabled(isFuture)
            
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
    
    // MARK: Generate Days
    
    func generateDays() -> [Int] {
        
        let range = calendar.range(
            of: .day,
            in: .month,
            for: Date()
        )!
        
        return Array(range)
    }
    
    
    func dateFromDay(_ day:Int) -> Date {
        
        let components = calendar.dateComponents(
            [.year,.month],
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
}
