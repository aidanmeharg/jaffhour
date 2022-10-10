//
//  JobView.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-30.
//

import SwiftUI

struct JobView: View {
    
    @Binding var job: Job
    
    @State private var editMode = EditMode.inactive
    
    @State var showAddSheet = false
    
    private let dateformatter = DateFormatter()
    
    init(job: Binding<Job>) {
        self._job = job
        dateformatter.dateFormat = "dd/MM/yyyy"
    }
    
    var body: some View {
        
            Form {
                if editMode == .active {
                    Section {
                        HStack {
                            Text("Rename: ")
                                
                            TextField("Job Name", text: $job.title) // this will be editable
                        }
                    }
                }
                Section {
                    Label("Date Started: \(dateformatter.string(from: job.startDate))", systemImage: "calendar")
                }
                Section {
                    Label("Total Hours: \(String(format: "%.2f", round(job.totalhours * 100) / 100.0))", systemImage: "clock")
                        
                }
                Section {
                    NavigationLink {
                        WorkDaysListView(job: $job)
                    } label: {
                        Label("Work Days", systemImage: "sun.max")
                    }
                }
                Section {
                    Button {
                        showAddSheet.toggle()
                    } label: {
                        Label("Add Workday", systemImage: "plus.circle")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.green)
            .environment(\.editMode, $editMode)
            .navigationTitle(job.title)
            .sheet(isPresented: $showAddSheet) {
                addWorkDayView(isPresented: $showAddSheet, job: $job)
            }
    }
    
    struct JobView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                JobView(job: .constant(Job.example))
            }
        }
    }
}
