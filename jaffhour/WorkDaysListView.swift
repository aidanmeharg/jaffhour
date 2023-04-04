//
//  WorkDaysListView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-01.
//

import SwiftUI

struct WorkDaysListView: View {
    
    @EnvironmentObject var model: ViewModel
    
    @Binding var job: Job
    
    @State private var selectedDays:  Set<WorkDay> = []
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        List(selection: $selectedDays) {
            ForEach($job.workdays) { workday in
                WorkDayRow(workday: workday, job: $job)
                    .environmentObject(model)
            }
            .listRowBackground(JaffPalette.midGreen)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .padding()
                    .disabled(job.workdays.isEmpty)
            }
            ToolbarItem(placement: .navigationBarTrailing) {

                Button(role: .destructive) {
                    job.delete(selectedDays)
                    selectedDays.removeAll()
                    editMode = .inactive
                } label: {
                    Label("Delete Selected", systemImage: "trash")
                    
                }
                .disabled(selectedDays.isEmpty || editMode == .inactive)
            }
        }
        .scrollContentBackground(.hidden)
        .background(JaffPalette.backgroundDark)
        .navigationTitle("Work Days")
        .environment(\.editMode, $editMode)
    }
}

struct WorkDaysListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkDaysListView(job: .constant(Job.example))
            .environmentObject(ViewModel())
    }
}
