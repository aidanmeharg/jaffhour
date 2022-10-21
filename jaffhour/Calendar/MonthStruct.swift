//
//  MonthStruct.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-20.
//

import Foundation

struct MonthStruct {
    
    var monthType: MonthType
    var dayInt: Int
    
    func day() -> String {
        return String(dayInt)
    }
    
}

enum MonthType {
    case Previous
    case Current
    case Next
}
