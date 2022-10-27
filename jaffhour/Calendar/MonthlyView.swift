//
//  MonthlyView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-20.
//

import SwiftUI

struct MonthlyView: View {
    
    @ObservedObject var model: ViewModel
    
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
    }
    
    var weekdayStack: some View {
        HStack(spacing: 20) {
            Text("S").dayOfWeek()
            //Spacer()
            Text("M").dayOfWeek()
            //Spacer()
            Text("T").dayOfWeek()
            //Spacer()
            Text("W").dayOfWeek()
            //Spacer()
            Text("T").dayOfWeek()
            //Spacer()
            Text("F").dayOfWeek()
            //Spacer()
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
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                            .environmentObject(dateHolder)
                    }
                }
            }
        }
    }
}

struct MonthlyView_Previews: PreviewProvider {
    static var previews: some View {
        //Form {
            MonthlyView(model: ViewModel())
                .environmentObject(DateHolder())
        //}
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
