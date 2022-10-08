//
//  WorkDayRow.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-01.
//

import SwiftUI

struct WorkDayRow: View {
    
    @Binding var workday: WorkDay
    
    var body: some View {
        NavigationLink {
            WorkDayDetailView(workday: $workday)
        } label: {
            Label("\(workday.dateFormatter.string(from: workday.date)) \(String(format: "%.2f", round(workday.hours * 100) / 100.0)) hours", systemImage: "calendar")
        }
        .tag(workday)
    }
}

struct WorkDayRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkDayRow(workday: .constant(WorkDay.example))
    }
}
