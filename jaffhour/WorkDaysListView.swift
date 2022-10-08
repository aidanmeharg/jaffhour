//
//  WorkDaysListView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-01.
//

import SwiftUI

struct WorkDaysListView: View {
    
    @Binding var job: Job
    
    @State private var selectedDays:  Set<WorkDay> = []
    
    var body: some View {
        List(selection: $selectedDays) {
            ForEach($job.workdays, content: WorkDayRow.init)
        }
        .navigationTitle("Work Days")
    }
}

struct WorkDaysListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkDaysListView(job: .constant(Job.example))
    }
}
