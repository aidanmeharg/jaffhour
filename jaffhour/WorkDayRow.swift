//
//  WorkDayRow.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-01.
//

import SwiftUI

struct WorkDayRow: View {
    
    @EnvironmentObject var model: ViewModel
    
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
            ScrollView {
                WorkdayCard(clientName: job.title, workday: $workday)
                    .environmentObject(model)
            }

        } label: {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.yellow)
                Text("\(dateformatter.string(from: workday.date)) \(String(format: "%.1f", round(workday.hours * 100) / 100.0)) hours")
                    .foregroundColor(JaffPalette.mintForeground)
            }
        }
        .tag(workday)
    }
}

struct WorkDayRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkDayRow(workday: .constant(WorkDay.example), job: .constant(Job.example))
            .environmentObject(ViewModel())
    }
}
