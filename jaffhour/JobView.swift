//
//  JobView.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-30.
//

import SwiftUI

struct JobView: View {
    
    @EnvironmentObject var model: ViewModel
    
    @Binding var job: Job
    
    @State private var editMode = EditMode.inactive
    
    @State private var startExpDate = Date()
    
    @State private var endExpDate = Date()
    
    @State private var hoursForSelectedRange: Double = 0.0
    
    @State var showAddSheet = false
    
    private let dateformatter = DateFormatter()
    
    init(job: Binding<Job>) {
        self._job = job
        dateformatter.dateFormat = "MMM dd yyyy"
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
    }
    
    var body: some View {
        
            Form {
                if editMode == .active {
                    Section {
                        HStack {
                            Text("Rename: ")
                                
                            TextField("Job Name", text: $job.title)
                                
                        }
                    }
                    
                }
                
                Section {
                    NavigationLink {
                        WorkDaysListView(job: $job)
                            .environmentObject(model)
                    } label: {
                        HStack {
                            Image(systemName: "sun.max")
                                .font(.title3.bold())
                                .foregroundColor(.yellow)
                            Text("Work Days")
                                .foregroundColor(JaffPalette.mintForeground)
                        }
                    }
                    .listRowBackground(JaffPalette.midGreen)
                }
                Section {
                    Button {
                        showAddSheet.toggle()
                    } label: {
                        Label("Add Workday", systemImage: "plus.circle")
                            .font(.title3.bold())
                    }
                    .listRowBackground(JaffPalette.midGreen)
                }
                Section {
                    VStack {
                        Text("Create Table for Workdays:")
                            .foregroundColor(JaffPalette.mintForeground)
                        HStack {
                            Spacer()
                            Text("Start:")
                                .foregroundColor(JaffPalette.mintForeground)
                            Spacer()
                            DatePicker("", selection: $startExpDate, displayedComponents: .date)
                                .font(.title2.bold())
                                .labelsHidden()
                                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                                    LinearGradient(colors: [.green, .green], startPoint: .topLeading, endPoint: .bottomTrailing)))
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("End:")
                                .foregroundColor(JaffPalette.mintForeground)
                            Spacer()
                            DatePicker("", selection: $endExpDate, displayedComponents: .date)
                                .font(.title2.bold())
                                .labelsHidden()
                                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                                    LinearGradient(colors: [.green, .green], startPoint: .topLeading, endPoint: .bottomTrailing)))
                            
                            Spacer()
                        }
                    }
                    .listRowBackground(JaffPalette.midGreen)
                }
                Section {
                    HStack {
                        Image(systemName: "clock")
                            .font(.title3.bold())
                            .foregroundColor(.yellow)
                        Text("Hours For Selected Range: \(String(format: "%.2f", hoursForSelectedRange))")
                                    .foregroundColor(JaffPalette.mintForeground)
                                    .onChange(of: startExpDate) { newValue in
                                        let hours = job.getHoursForDateRange(start: startExpDate, end: endExpDate)
                                        hoursForSelectedRange = round(hours * 100) / 100.0
                                        }
                                    .onChange(of: endExpDate) { newValue in
                                        let hours = job.getHoursForDateRange(start: startExpDate, end: endExpDate)
                                        hoursForSelectedRange = round(hours * 100) / 100.0
                            }
                    
                    }
                    .listRowBackground(JaffPalette.midGreen)
                }
                Section {
                    CSVExportView(job: job, start: startExpDate, end: endExpDate)
                        .listRowBackground(JaffPalette.midGreen)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .scrollContentBackground(.hidden)
            .background(JaffPalette.backgroundDark)
            .environment(\.editMode, $editMode)
            .navigationTitle(job.title)
            .sheet(isPresented: $showAddSheet) {
                addWorkDayView(isPresented: $showAddSheet, job: $job)
                    .environmentObject(model)
            }
    }
    
    struct JobView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                JobView(job: .constant(Job.example))
                    .environmentObject(ViewModel())
            }
        }
    }
}
