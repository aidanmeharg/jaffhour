//
//  WorkdaysTable.swift
//  jaffhour
//
//  Created by Aidan on 2022-11-04.
//

import SwiftUI

struct WorkdaysTable: View {
    
    var jobs: [Job]
    let selectedDay: Date
    let dateFormatter = DateFormatter()
    
    init(jobs: [Job], selectedDay: Date) {
        self.jobs = jobs
        self.selectedDay = selectedDay
        dateFormatter.dateFormat = "EEEE MMM dd yyyy"
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .none
        
    }
    
    var body: some View {
        // should this also be a scrollview of some sort?
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                Text("\(dateFormatter.string(from: selectedDay))")
                    .font(.largeTitle.bold())
                ForEach(jobs) { job in
                    
                    ForEach(job.workdays) { workday in
                        if (Calendar.current.isDate(selectedDay, equalTo: workday.date, toGranularity: .day)) {
                            VStack {
                                Text("\(job.title)") // Note: this will display client name multiple times if multiple workdays logged on same date
                                    .font(.largeTitle.bold())
                                    .padding(.top)
                                    .padding(.horizontal)
                                Spacer()
                                
                                WorkDayDetailView(workday: workday)
                            }
                        }
                    }
                }
            }
        }
        
    }
}

struct WorkdaysTable_Previews: PreviewProvider {
    static var previews: some View {
        WorkdaysTable(jobs: [Job.example, Job.exampleThree], selectedDay: Date())
    }
}
