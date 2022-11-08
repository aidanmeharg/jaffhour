//
//  ViewModel.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-29.
//

import Foundation
import Combine


class ViewModel: ObservableObject {
    
    // URL for saving/loading JSON data
    private let savePathJobs = FileManager.documentsDirectory.appendingPathComponent("SavedJobs")
    private let savePathPayees = FileManager.documentsDirectory.appendingPathComponent("SavedPayees")
    
    // An active Combine chain that watches for changes to the `jobs` array, and calls save()
    // 5 seconds after a change has happened.
    // NOTE: app will only save a new payee if they are added to a Job
    private var saveSubscription: AnyCancellable?
    
    @Published var jobs: [Job]
    
    var globalpayees = GlobalPayees.sharedInstance
    
    
    init() {
        do {
            let job_data = try Data(contentsOf: savePathJobs)
            let payee_data = try Data(contentsOf: savePathPayees)
            jobs = try JSONDecoder().decode([Job].self, from: job_data)
            globalpayees.payees = try JSONDecoder().decode([String].self, from: payee_data)
        } catch {
            // loading failed: start with new data
            jobs = []
            globalpayees.payees = []
        }
        // sort jobs in case of previous changes made 
        for var job in jobs {
            job.workdays.sort {
                $0.date > $1.date
            }
        }
        
        // Wait 5 seconds after `jobs` has changed before calling `save()`, to
        // avoid repeatedly calling it for every tiny change.
        saveSubscription = $jobs // TODO: this won't check for changes to globalPayees, should probably put payees in here
            .debounce(for: 5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.save()
                    }
        
    }
    
    // Convert jobs to JSON and save to disk
    func save() {
        do {
            let job_data = try JSONEncoder().encode(jobs)
            try job_data.write(to: savePathJobs, options: [.atomic, .completeFileProtection])
            let payee_data = try JSONEncoder().encode(globalpayees.payees)
            try payee_data.write(to: savePathPayees, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
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
