//
//  WorkDayRow.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-01.
//

import SwiftUI

struct WorkDayRow: View {
    
    @Binding var workday: WorkDay
    
    private let dateformatter = DateFormatter()
    
    init(workday: Binding<WorkDay>) {
        self._workday = workday
        dateformatter.dateFormat = "dd/MM/yyyy"
    }
    
    var body: some View {
        NavigationLink {
            WorkDayDetailView(workday: $workday)
        } label: {
            Label("\(dateformatter.string(from: workday.date)) \(String(format: "%.2f", round(workday.hours * 100) / 100.0)) hours", systemImage: "calendar")
        }
        .tag(workday)
    }
}

struct WorkDayRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkDayRow(workday: .constant(WorkDay.example))
    }
}
