//
//  CalendarCell.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-20.
//

import SwiftUI

struct CalendarCell: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    // ideally each CalendarCell should represent their respective date
    @State var tapped = false
    @Binding var showDaySheet: Bool
    @Binding var selectedDay: Date
    
    
    var body: some View {
        ZStack {
            Circle()
                //.imageScale(.small)
                .foregroundColor(tapped ? Color.green : circleColor())
            Text(monthStruct().day())
                .foregroundColor(textColor(type: monthStruct().monthType))
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            //tapped.toggle()
            updateSelectedDay()
            showDaySheet.toggle()
        }
        
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black : Color.gray
    }
    
    func updateSelectedDay() {
        let start = startingSpaces == 0 ? startingSpaces + 7: startingSpaces
        
        selectedDay = Calendar.current.date(byAdding: .day, value: count - start - 1, to: CalendarHelper().firstOfMonth(date: dateHolder.date))!
    }
    
    func circleColor() -> Color {
        let oneDay = Color(red: 156/255, green: 233/255, blue: 172/255)
        let twoDays = Color(red: 68/255, green: 196/255, blue: 106/255)
        let threePlus = Color(red: 51/255, green: 161/255, blue: 83/255)
        let start = startingSpaces == 0 ? startingSpaces + 7: startingSpaces
        let isToday = CalendarHelper().isToday(date: Calendar.current.date(byAdding: .day, value: count - start - 1, to: CalendarHelper().firstOfMonth(date: dateHolder.date))!)
        // TODO: connect this view with viewmodel and get # of jobs with a workday on this day
        return isToday ? Color.green : oneDay
    }
    
    
    
    func monthStruct() -> MonthStruct {
        
        let start = startingSpaces == 0 ? startingSpaces + 7: startingSpaces
        if (count <= start) {
            return MonthStruct(monthType: MonthType.Previous, dayInt: daysInPrevMonth + count - start)
        } else if (count - start > daysInMonth) {
            return MonthStruct(monthType: MonthType.Next, dayInt: count - start - daysInMonth)
        }
        return MonthStruct(monthType: MonthType.Current, dayInt: count - start)
    }
    
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1, showDaySheet: .constant(false), selectedDay: .constant(Date()))
            .environmentObject(DateHolder())
    }
}
