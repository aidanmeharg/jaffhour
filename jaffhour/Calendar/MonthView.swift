//
//  MonthView.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-23.
//

import SwiftUI

struct MonthView: View {
    
    @Namespace var namespace
    
    @EnvironmentObject var model: ViewModel
    
    @State var showingDayDetails = false
    
    @State var dateForDetailView = Date()
    
    @EnvironmentObject var dateHolder: DateHolder
    
    
    var body: some View {
        
        ZStack {
            if (!showingDayDetails) {
                ZStack {
                    LinearGradient(colors: [.clear, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                        .matchedGeometryEffect(id: "background", in: namespace)
                    VStack {
                        MonthScrollerView()
                            .environmentObject(dateHolder)
                            .padding(.vertical)
                        
                        weekdayStack
                        
                        calGrid
                    }
                    
                }
            } else {
                VStack {
                    DayDetailView(namespace: namespace, showingDayDetails: $showingDayDetails, date: dateForDetailView)
                        .environmentObject(model)
                }
            }
        }
            
         
        
    }
    
    var weekdayStack: some View {
        HStack {
            Text("S").dayOfWeek()
            Text("M").dayOfWeek()
            Text("T").dayOfWeek()
            Text("W").dayOfWeek()
            Text("T").dayOfWeek()
            Text("F").dayOfWeek()
            Text("S").dayOfWeek()
        }
    }
    
    var calGrid: some View {
        
        VStack {
            let firstDayOfMonth = CalendarHelper().firstOfMonth(date: dateHolder.date)
            let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
            
            ForEach(0..<6) { row in
                HStack(spacing: 1) {
                    ForEach(0..<7) { column in
                        let count = column + (row * 7)
                        let start = startingSpaces == 0 ? startingSpaces + 7: startingSpaces
                        let day = Calendar.current.date(byAdding: .day, value: count - start - 1, to: CalendarHelper().firstOfMonth(date: dateHolder.date))!
                        DateCell(namespace: namespace, showingDayDetails: $showingDayDetails, date: day, dateForDetailView: $dateForDetailView)
                            .environmentObject(dateHolder)
                            .environmentObject(model)
                            
                    }
                }
            }
        }
        
    }
    
}



struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
    
        MonthView()
                .environmentObject(ViewModel())
                .environmentObject(DateHolder())
    }
}


//extension Text {
//
//    func dayOfWeek() -> some View {
//            self.font(.title2.bold()).frame(maxWidth: .infinity)
//
//    }
//}

