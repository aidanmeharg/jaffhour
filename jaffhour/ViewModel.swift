//
//  ViewModel.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-29.
//

import Foundation
import Combine
import SwiftUI


class ViewModel: ObservableObject {
    
    // URL for saving/loading JSON data
    private let savePathJobs = FileManager.documentsDirectory.appendingPathComponent("SavedJobs")
    private let savePathPayees = FileManager.documentsDirectory.appendingPathComponent("SavedPayees")
//    private let savePathPayeesStruct = FileManager.documentsDirectory.appendingPathComponent("SavedPayeesStruct")
    
    // An active Combine chain that watches for changes to the `jobs` array, and calls save()
    // 5 seconds after a change has happened.
    // NOTE: app will only save a new payee if they are added to a Job
    private var saveSubscription: AnyCancellable?
    
    @Published var jobs: [Job]
    
    @Published var payees: [String]
    
    let dayFormatter = DateFormatter()
    
    let monthFormatter = DateFormatter()
    
    let yearFormatter = DateFormatter()
    
    let dayOfWeekFormatter = DateFormatter()
    
    let mdyFormatter = DateFormatter()
    
    let timeFormatter = DateFormatter()
    
    // TODO: use one dateFormatter and call functions
    //       also move all this date formatting stuff into a class in the calendar folder
    
    var globalpayees = GlobalPayees.sharedInstance
    
    
    init() {
        do {
            mdyFormatter.dateFormat = "MMM-dd-yyyy"
            dayOfWeekFormatter.dateFormat = "EEEE"
            yearFormatter.dateFormat = "YYYY"
            dayFormatter.dateFormat = "d"
            monthFormatter.dateFormat = "MMMM"
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            let job_data = try Data(contentsOf: savePathJobs)
            let payee_data = try Data(contentsOf: savePathPayees)
//            let payee_struct_data = try Data(contentsOf: savePathPayeesStruct)
            jobs = try JSONDecoder().decode([Job].self, from: job_data)
//            payees = try JSONDecoder().decode([Payee].self, from: payee_struct_data)
            globalpayees.payees = try JSONDecoder().decode([String].self, from: payee_data)
            globalpayees.payees.sort() // TODO: absolutely no reason to sort these on startup
            // TODO: after jaff has updated, get rid of globalpayees entirely
            payees = []
            for pname in globalpayees.payees {
                payees.append(pname)
            }
        } catch {
            // loading failed: start with new data
            jobs = []
            payees = []
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
        saveSubscription = $jobs // TODO: this won't check for changes to globalPayees, payee won't save unless they are added in an expense
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
            let payee_data = try JSONEncoder().encode(payees)
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
    
    func addJob(title: String) {
        if (!jobs.contains(where: {$0.title == title}) && title != "") {
            jobs.append(Job(title: title, workdays: []))
        }
    }
    
    
    func addWorkdayForClient(clientName: String, date: Date) {
        if (clientName != "") {
            if let index = jobs.firstIndex(where: {$0.title == clientName}) {
                jobs[index].workdays.append(WorkDay(date: date, tasks: "", notes: ""))
                objectWillChange.send()
            }
        }
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
    
    func addPayee(name: String) {
        if (!payees.contains(name) && name != "") {
            payees.append(name)
        }
    }
}
