//
//  ViewModel.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-29.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var jobs: [Job]
    
    @Published var payees: [String]
    
    
    init() {
        jobs = [Job.example, Job.exampleTwo, Job.exampleThree]
        payees = ["Home Depot", "A&B Tools", "Dicks Lumber"]
        
    }
    
    func addJob() {
        var newJob = Job(title: "New Job", workdays: [])
        jobs.append(newJob)
        newJob.updateTotalHours()
        
    }
    
    func move(from source: IndexSet, to destination: Int) {
        jobs.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(_ offSets: IndexSet) {
        jobs.remove(atOffsets: offSets)
    }
    
    func delete(_ selected: Set<Job>) {
           jobs.removeAll(where: selected.contains)
       }
}
