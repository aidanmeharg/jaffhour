//
//  ContentView.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-27.
//

import SwiftUI

// TODO: make payees editable (remove payees)
 

struct ContentView: View {
    
    @EnvironmentObject var model: ViewModel
    
    @State private var selectedJobs:  Set<Job> = []
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
    
        VStack {
            List(selection: $selectedJobs) {
                ForEach($model.jobs) { $job in
                    JobRow(job: $job)
                        .environmentObject(model)
//                        .onMove(perform: model.move)
                }
                
                Spacer()
                Text("Edit Payees:")
                    .font(.title2.bold())
                NavigationLink {
                    EditPayeesView()
                } label: {
                    Label("", systemImage: "gearshape.fill")
                }
            }
            
        }
        //.scrollContentBackground(.hidden)
        //.background(Color.green)
        
        
        .navigationTitle("Clients")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .padding()
                    .disabled(model.jobs.isEmpty)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: model.addJob) {
                    Label("Add New Job", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
               
                        
                        Button(role: .destructive) {
                            model.delete(selectedJobs)
                            selectedJobs.removeAll()
                            editMode = .inactive
                        } label: {
                            Label("Delete Selected", systemImage: "trash")
                                
                        }
                        .disabled(selectedJobs.isEmpty || editMode == .inactive)
                        
                        
                    
                
            }
        }
        .environment(\.editMode, $editMode)
        
    }
        
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
                .environmentObject(ViewModel())
        }
    }
}
