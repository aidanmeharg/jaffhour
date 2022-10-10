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
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedItems")
    
    // An active Combine chain that watches for changes to the `items` array, and calls save()
    // 5 seconds after a change has happened.
    private var saveSubscription: AnyCancellable?
    
    @Published var jobs: [Job]
    
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            jobs = try JSONDecoder().decode([Job].self, from: data)
        } catch {
            // loading failed: start with new data
            jobs = []
        }
        
        // Wait 5 seconds after `jobs` has changed before calling `save()`, to
        // avoid repeatedly calling it for every tiny change.
        saveSubscription = $jobs // TODO: this won't check for changes to globalPayees, should probably put payees in here
            .debounce(for: 5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.save()
                    }
//        jobs = [Job.example, Job.exampleTwo, Job.exampleThree]
//        payees = ["Home Depot", "A&B Tools", "Dicks Lumber"]
        
    }
    
    // Convert jobs to JSON and save to disk
    func save() {
        do {
            let data = try JSONEncoder().encode(jobs)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
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
