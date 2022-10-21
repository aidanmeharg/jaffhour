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
    
    var body: some View {
        Text(monthStruct().day())
            .foregroundColor(textColor(type: monthStruct().monthType))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black : Color.gray
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
