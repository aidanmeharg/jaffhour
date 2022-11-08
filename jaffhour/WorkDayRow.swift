//
//  WorkDayRow.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-01.
//

import SwiftUI

struct WorkDayRow: View {
    
    @Binding var workday: WorkDay
    
    @Binding var job: Job
    
    private let dateformatter = DateFormatter()
    
    init(workday: Binding<WorkDay>, job: Binding<Job>) {
        self._workday = workday
        self._job = job
        dateformatter.dateFormat = "EE MMM dd yyyy"
    }
    
    var body: some View {
        NavigationLink {
            EditableWorkDayView(editableWorkday: workday, workday: $workday, job: $job)
        } label: {
            Label("\(dateformatter.string(from: workday.date)) \(String(format: "%.1f", round(workday.hours * 100) / 100.0)) hours", systemImage: "calendar")
        }
        .tag(workday)
    }
}

struct WorkDayRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkDayRow(workday: .constant(WorkDay.example), job: .constant(Job.example))
    }
}
