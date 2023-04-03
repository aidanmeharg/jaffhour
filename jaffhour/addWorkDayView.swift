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
                .foregroundColor(JaffPalette.mintForeground)
            Text("\(job.title)")
                .foregroundColor(JaffPalette.mintForeground)
            
            
           
            Form {
                
                HStack {
                    Text("Date")
                        .foregroundColor(JaffPalette.mintForeground)
                    DatePicker("", selection: $workday.date, displayedComponents: .date)
                        .font(.title2.bold())
                        .labelsHidden()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                            LinearGradient(colors: [.green, .green], startPoint: .topLeading, endPoint: .bottomTrailing)))
                }
                .listRowBackground(JaffPalette.midGreen)
                
                HStack {
                    Text("Start")
                        .foregroundColor(JaffPalette.mintForeground)
                    DatePicker("", selection: $workday.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                            LinearGradient(colors: [.green, .green], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    
                    Text("End")
                        .foregroundColor(JaffPalette.mintForeground)
                    DatePicker("", selection: $workday.endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                            LinearGradient(colors: [.green, .green], startPoint: .topLeading, endPoint: .bottomTrailing)))
                }
                .listRowBackground(JaffPalette.midGreen)
                
                
                
                Section {
                    Text("Tasks")
                        .font(.title)
                        .foregroundColor(JaffPalette.mintForeground)
                        .listRowBackground(JaffPalette.midGreen)
                    TextEditor(text: $workday.tasks)
                        .listRowBackground(Color.green)
                    
                }
                Section {
                    Text("Expenses")
                        .font(.title)
                        .foregroundColor(JaffPalette.mintForeground)
                        .listRowBackground(JaffPalette.midGreen)
                    List {
                        ForEach($expenses, id: \.id) { $expense in
                            addExpenseView(expense: $expense)
                                .environmentObject(model)
                                
                        }
                        .onDelete(perform: removeRows)
                    }
                    .listRowBackground(Color.green)
                    
                    
                }
                Section {
                    Button {
                        expenses.append(Expense(name: "", description: "", amount: 0))
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.yellow)
                            Text("Add Expense")
                                .foregroundColor(JaffPalette.mintForeground)
                        }
                
                    }
                    .listRowBackground(JaffPalette.midGreen)
                    
                }
                Section {
                    Text("Notes")
                        .font(.title)
                        .foregroundColor(JaffPalette.mintForeground)
                        .listRowBackground(JaffPalette.midGreen)
                    TextEditor(text: $workday.notes)
                        .listRowBackground(Color.green)
                    
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
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.yellow)
                        Text("Save This Workday")
                            .foregroundColor(JaffPalette.mintForeground)
                    }

                }
                .buttonStyle(BorderlessButtonStyle())
                .listRowBackground(JaffPalette.midGreen)
            }
                .alert(isPresented: $invalidDay) {
                    Alert(title: Text("Highly Doubtful that you worked for \(String(format: "%.2f", round(workday.hours * 100) / 100.0)) hours... unless you're building a time machine?"))
                }
                
                //.scrollContentBackground(.hidden)
//                .background(Color.green)
                
                
            }
        .background(JaffPalette.backgroundDark)
            
        }
    }
    
    struct addWorkDayView_Previews: PreviewProvider {
        static var previews: some View {
            addWorkDayView(isPresented: .constant(true), job: .constant(Job.example))
                .environmentObject(ViewModel())
        }
    }

