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
        
        VStack {
            MonthScrollerView()
                .environmentObject(dateHolder)
                .padding(.vertical)
        
            weekdayStack
                
            calendarGrid
            
        }
        .padding(.horizontal)
        .sheet(isPresented: $showDaySheet) {
            WorkdaysTable(jobs: model.jobs, selectedDay: selectedDay)
            // make this view accept a list of workdays
            // add method to get workdays from model for selectedDay
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
    
    var calendarGrid: some View {
        
        VStack {
            let daysInMonth = CalendarHelper().daysInMonth(date: dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(date: dateHolder.date)
            let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
            let prevMonth = CalendarHelper().decMonth(date: dateHolder.date)
            let daysInPrevMonth = CalendarHelper().daysInMonth(date: prevMonth)
            
            ForEach(0..<6) { row in
                HStack(spacing: 1) {
                    ForEach(0..<7) { column in
                        let count = column + (row * 7)
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, showDaySheet: $showDaySheet, selectedDay: $selectedDay, jobs: model.jobs)
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
            self.font(.title2.bold()).frame(maxWidth: .infinity)
        
    }
}
