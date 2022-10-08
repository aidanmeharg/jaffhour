//
//  ContentView.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-27.
//

import SwiftUI

// possibly add an options menu to edit: payees 

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    
    @State private var selectedJobs:  Set<Job> = []
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
    
        List(selection: $selectedJobs) {
            ForEach($model.jobs, content: JobRow.init)
                .onMove(perform: model.move)
            
        }
        .scrollContentBackground(.hidden)
        .background(Color.green)
        
        
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
            ToolbarItem(placement: .bottomBar) {
               
                    HStack {
                        
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
        }
        .environment(\.editMode, $editMode)
        
    }
        
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(model: ViewModel())
        }
    }
}
