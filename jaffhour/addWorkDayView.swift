//
//  addWorkDayView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-01.
//

import SwiftUI

struct addWorkDayView: View {
    
    @EnvironmentObject var model: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresented: Bool
    
    @Binding var job: Job
    
    @State private var workday = WorkDay(tasks: "", notes: "")
    
    @State private var expenses: [Expense] = []
    
    @State private var invalidDay = false
    
    func removeRows(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
    
    
    
    var body: some View {
        VStack {
            Spacer()
            Text("New Work Day")
                .font(.largeTitle)
            Text("\(job.title)")
            
            
           
            Form {
                
                HStack {
                    Text("Date")
                    DatePicker("", selection: $workday.date, displayedComponents: .date)
                        .labelsHidden()
                }
                
                HStack {
                    Text("Start")
                    DatePicker("", selection: $workday.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    
                    Text("End")
                    DatePicker("", selection: $workday.endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                
                
                Section {
                    Text("Tasks")
                        .font(.title)
                    TextEditor(text: $workday.tasks)
                    
                }
                Section {
                    Text("Expenses")
                        .font(.title)
                    List {
                        ForEach($expenses, id: \.id) { $expense in
                            addExpenseView(expense: $expense)
                                .environmentObject(model)
                                
                        }
                        .onDelete(perform: removeRows)
                    }
                    
                    
                }
                Section {
                    Button {
                        expenses.append(Expense(name: "", description: "", amount: 0))
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                    
                }
                Section {
                    Text("Notes")
                        .font(.title)
                    TextEditor(text: $workday.notes)
                    
                }
                Button {
                    workday.updateHours()
                    
                    workday.expenses.append(contentsOf: expenses)
                    if (!job.addWorkDay(workday: workday)) {
                        invalidDay = true
                        return
                    } else {
                        job.updateTotalHours()
                        job.updateTotalExpenses()
                        job.workdays.sort {
                            $0.date > $1.date
                        }
                        isPresented = false
                    }
                } label: {
                    Label("save this workday", systemImage: "checkmark")

                }
                .buttonStyle(BorderlessButtonStyle())
            }
                .alert(isPresented: $invalidDay) {
                    Alert(title: Text("Highly Doubtful that you worked for \(String(format: "%.2f", round(workday.hours * 100) / 100.0)) hours... unless you're building a time machine?"))
                }
                
                //.scrollContentBackground(.hidden)
                //.background(Color.green)
                
                
            }
            
        }
    }
    
    struct addWorkDayView_Previews: PreviewProvider {
        static var previews: some View {
            addWorkDayView(isPresented: .constant(true), job: .constant(Job.example))
                .environmentObject(ViewModel())
        }
    }

