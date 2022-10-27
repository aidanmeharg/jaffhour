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
    @State var tapped = false
    
    
    var body: some View {
        ZStack {
            Circle()
                .imageScale(.small)
                .foregroundColor(tapped ? Color.green : circleColor())
            Text(monthStruct().day())
                .foregroundColor(textColor(type: monthStruct().monthType))
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            tapped.toggle()
        }
        
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black : Color.gray
    }
    
    func circleColor() -> Color {
        let start = startingSpaces == 0 ? startingSpaces + 7: startingSpaces
        let isToday = CalendarHelper().isToday(date: Calendar.current.date(byAdding: .day, value: count - start - 1, to: CalendarHelper().firstOfMonth(date: dateHolder.date))!)
        return isToday ? Color.red : Color.clear
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
        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
            .environmentObject(DateHolder())
    }
}
