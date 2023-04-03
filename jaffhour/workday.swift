//
//  workday.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-29.
//

import Foundation

//struct Payee: Hashable, Identifiable, Codable, Equatable { overkill
//
//    var id = UUID()
//
//    var name: String
//}


struct Expense: Hashable, Identifiable, Codable {
    
    var id = UUID()
    
    var name: String
    
    var description: String
    
    var amount: Double
    
    static let example1 = Expense(name: "A&B", description: "tool rental", amount: 112.38)
    static let example2 = Expense(name: "District 11", description: "that good food forreal", amount: 48.77)
    static let example3 = Expense(name: "Home Depot", description: "a very long description of the expense (with lots of details) use this to test out views that display expenses so that we can format correctly", amount: 420.69)
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
    
    static let example = WorkDay(date: Date(), expenses: [Expense.example1, Expense.example2, Expense.example3], tasks: "Worked on JaffHour", notes: "Not much to say")
}

extension WorkDay {
    
    struct Data {
        
        var date: Date = Date()
        
        var startTime: Date = Date()
        
        var endTime: Date = Date()
        
        var hours: Double = 0.0
        
        var tasks: String = ""
        
        var expenses: [Expense] = []
        
        var totalExpenses: Double = 0.0 // this is stupid don't use this
        
        var notes: String = ""
        
        mutating func deleteExpense(selected: Expense) {
            let deleteIndex = expenses.firstIndex(where: {$0.id == selected.id})
            if (deleteIndex != nil) {
                expenses.remove(at: deleteIndex!)
            }
        }
        
        mutating func addNewExpense() {
            expenses.append(Expense(name: "", description: "", amount: 0.0))
        }
        
    }
    
    var data: Data {
        Data(date: date, startTime: startTime, endTime: endTime, hours: hours, tasks: tasks, expenses: expenses, totalExpenses: totalExpenses, notes: notes)
    }
    
    
    mutating func update(from data: Data) {
        date = data.date
        startTime = data.startTime
        endTime = data.endTime
        tasks = data.tasks
        expenses = data.expenses
        notes = data.notes
        // recalculate hours
        hours = data.endTime.timeIntervalSince(data.startTime) / 3600.0
    }
    
}

struct Job: Hashable, Identifiable, Codable {
     
    var id = UUID()
    
    var title: String
    
    var workdays: [WorkDay]
    
    var payees: [String]
    
    var startDate = Date()
    
    var totalhours: Double // NOT IN USE
    
    var totalExpenses: Double // NOT IN USE
    
    func getHoursForDateRange(start: Date, end: Date) -> Double {
        var total = 0.0
        for workday in workdays {
            if (start <= workday.startTime && end >= workday.endTime) { // TODO: debug to see why this is messing up
                total += workday.hours
            }
        }
        return total
    }
    
    mutating func sortWorkdays() {
        workdays.sort {
            $0.date > $1.date
        }
    }
    
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


