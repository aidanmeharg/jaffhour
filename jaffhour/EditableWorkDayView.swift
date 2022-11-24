//
//  EditableWorkDayView.swift
//  jaffhour
//
//  Created by Aidan on 2022-11-06.
//

import SwiftUI

struct EditableWorkDayView: View {
    
    @State var editableWorkday: WorkDay
    
    @Binding var workday: WorkDay
    
    @Binding var job: Job
    
    func removeRows(at offsets: IndexSet) {
        editableWorkday.expenses.remove(atOffsets: offsets)
    }

    // This is pretty much duplicate of addWorkDayView
    // TODO: GET SOME REFACTORING DONE!
    
    var body: some View {
        
        
        Form {
            
            HStack {
                Text("Date")
                DatePicker("", selection: $editableWorkday.date, displayedComponents: .date)
                    .labelsHidden()
            }

            HStack {
                Text("Start")
                DatePicker("", selection: $editableWorkday.startTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()

                Text("End")
                DatePicker("", selection: $editableWorkday.endTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            
            Section {
                Text("Tasks")
                    .font(.title)
                TextField("What got done?", text: $editableWorkday.tasks, axis: .vertical)
                // , axis: .vertical
            }
            Section {
                Text("Expenses")
                    .font(.title)
                List {
                    ForEach($editableWorkday.expenses, id: \.id) { expense in
                        addExpenseView(expense: expense)
                    }
                    .onDelete(perform: removeRows)
                }
            }
            Section {
                Button {
                    editableWorkday.expenses.append(Expense(name: "", description: "", amount: 0))
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
                
            }
            Section {
                Text("Notes")
                    .font(.title)
                TextField("Additional Notes", text: $editableWorkday.notes, axis: .vertical)
                
            }
            
            
        }
        
        .onDisappear(perform: {
            editableWorkday.updateHours()
            if (editableWorkday.hours < 0) {
                return // should show some kind of error message
            }
            let dateChanged = editableWorkday.date != workday.date
            let hoursChanged = editableWorkday.hours != workday.hours
            workday = editableWorkday
            if (hoursChanged) {
                job.updateTotalHours()
            }
            job.updateTotalExpenses()
            if (dateChanged) {
                job.workdays.sort {
                    $0.date > $1.date
                }
            }
            
        }) // update the binding workday
    }
}

struct EditableWorkDayView_Previews: PreviewProvider {
    static var previews: some View {
        EditableWorkDayView(editableWorkday: WorkDay.example, workday: .constant(WorkDay.example), job: .constant(Job.example))
    }
}
