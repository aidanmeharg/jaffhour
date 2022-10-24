//
//  CalendarHelper.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-20.
//

import Foundation

class CalendarHelper {
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    func monthYearString(date: Date) -> String {
        dateFormatter.dateFormat = "LLL yyyy"
        return dateFormatter.string(from: date)
    }
    
    func incMonth(date: Date) -> Date {
        
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func decMonth(date: Date) -> Date {
        
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 2
    }
    
    // find a better way to do this
    func isToday(date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
}
