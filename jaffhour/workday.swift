//
//  workday.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-29.
//

import Foundation


struct Expense: Hashable, Identifiable, Codable {
    
    var id = UUID()
    
    var name: String
    
    var description: String
    
    var amount: Double
    
    static let example1 = Expense(name: "A&B", description: "tool rental", amount: 112.38)
    static let example2 = Expense(name: "District 11", description: "that good food forreal", amount: 48.77)
}


struct WorkDay: Hashable, Identifiable, Codable {
    
    var id = UUID()
    
    var date = Date()
    
    var startTime: Date
    
    var endTime: Date
    
    var hours: Double
    
    var tasks: String
    
    var expenses: [Expense]
    
    var totalExpenses: Double
    
    var notes: String
    
    
    // Default 9-5 of current day
    init(date: Date = Date(), startTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(), endTime: Date = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date(), expenses: [Expense] = [], totalExpenses: Double = 0.0, tasks: String, notes: String) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.hours = endTime.timeIntervalSince(startTime) / 3600.0
        self.tasks = tasks
        self.expenses = expenses
        self.totalExpenses = totalExpenses
        self.notes = notes
    }
    
    mutating func updateHours() {
        hours = endTime.timeIntervalSince(startTime) / 3600.0
    }
    
    static let example = WorkDay(date: Date(), expenses: [Expense.example1, Expense.example2], tasks: "Worked on JaffHour", notes: "Not much to say")
}

struct Job: Hashable, Identifiable, Codable {
     
    var id = UUID()
    
    var title: String
    
    var workdays: [WorkDay]
    
    var payees: [String]
    
    var startDate = Date()
    
    var totalhours: Double
    
    var totalExpenses: Double
    
    // totalhours should always reflect data accurately but avoid recomputation
    mutating func updateTotalHours() {
        let hours = workdays.map({$0.hours})
        totalhours = hours.reduce(0, +)
    }
    
    mutating func updateTotalExpenses() {
        let day_expenses = workdays.map({$0.totalExpenses})
        totalExpenses = day_expenses.reduce(0, +)
    }
    
    // Requires: Workday hours have been updated before this call
    // return: false if day is invalid
    mutating func addWorkDay(workday: WorkDay) -> Bool {
        if (workday.hours <= 0) {
            return false
        } else {
            workdays.append(workday)
            return true
        }
    }
    
    mutating func delete(_ offSets: IndexSet) {
        workdays.remove(atOffsets: offSets)
    }
    
    mutating func delete(_ selected: Set<WorkDay>) {
           workdays.removeAll(where: selected.contains)
        updateTotalHours()
        updateTotalExpenses()
       }
    
    
    init(title: String, workdays: [WorkDay] = [], payees: [String] = [], totalhours: Double = 0.0, totalExpenses: Double = 0.0) {
        self.title = title
        self.workdays = workdays
        self.payees = payees
        self.totalhours = totalhours
        self.totalExpenses = totalExpenses
        updateTotalHours()
        updateTotalExpenses()
    }

    
    
    
    static let example = Job(title: "JaffHour Project", workdays: [WorkDay.example], payees: ["A&B", "District 11"])
    static let exampleTwo = Job(title: "Stats Project", workdays: [WorkDay.example])
    static let exampleThree = Job(title: "co-op", workdays: [WorkDay.example])
}


