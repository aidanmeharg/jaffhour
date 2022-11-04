//
//  MonthlyView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-20.
//

import SwiftUI

struct MonthlyView: View {
    
    @ObservedObject var model: ViewModel
    
    @State var showDaySheet = false
    
    @State var selectedDay = Date()
    
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
      
        VStack(spacing: 1) {
            MonthScrollerView()
                .environmentObject(dateHolder)
                .padding()
            weekdayStack
                .padding()
            calendarGrid
        }
        .padding(.horizontal)
        .sheet(isPresented: $showDaySheet) {
            WorkDayDetailView(workday: .constant(WorkDay(date: selectedDay, expenses: [], tasks: "bruh", notes: "quandii")))
        }
        
    }
    
    var weekdayStack: some View {
        HStack(spacing: 20) {
            Text("S").dayOfWeek()
            Text("M").dayOfWeek()
            Text("T").dayOfWeek()
            Text("W").dayOfWeek()
            Text("T").dayOfWeek()
            Text("F").dayOfWeek()
            Text("S").dayOfWeek()
            
        }
    }
    
    var calendarGrid: some View {
        
        VStack(spacing: 1) {
            let daysInMonth = CalendarHelper().daysInMonth(date: dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(date: dateHolder.date)
            let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
            let prevMonth = CalendarHelper().decMonth(date: dateHolder.date)
            let daysInPrevMonth = CalendarHelper().daysInMonth(date: prevMonth)
            
            ForEach(0..<6) { row in
                HStack(spacing: 1) {
                    ForEach(0..<7) { column in
                        let count = column + (row * 7)
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, showDaySheet: $showDaySheet, selectedDay: $selectedDay)
                            .environmentObject(dateHolder)
                            
                    }
                }
            }
        }
        
    }
}

struct MonthlyView_Previews: PreviewProvider {
    static var previews: some View {
    
            MonthlyView(model: ViewModel())
                .environmentObject(DateHolder())
    }
}


extension Text {
    
    func dayOfWeek() -> some View {
        ZStack {
            Circle()
                .imageScale(.small)
                .foregroundColor(.clear)
            self.font(.title2.bold())
                //.lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        
    }
}
