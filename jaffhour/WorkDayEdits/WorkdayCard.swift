//
//  WorkdayCard.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-24.
//

import SwiftUI

struct WorkdayCard: View {
    
    @Namespace var detailAnimation
    
    @EnvironmentObject var model: ViewModel
    
    @State private var showingDetails: Bool = false
    
    @State private var inEditMode: Bool = false
    
    @State private var workdayData = WorkDay.Data()
    
    var clientName: String
    
    @Binding var workday: WorkDay
    
    // to toggle payee add textfield
    @State var addingPayee: Bool = false // TODO: move out into editview
    
    @State var showInvalidHoursMessage: Bool = false
    
    @State var newPayeeName: String = ""
    
    var body: some View {
        
        ZStack {
            if (!showingDetails) {
                Group {
                    HStack {
                        Text(clientName)
                            .font(.title.bold())
                            .padding()
                            .foregroundColor(JaffPalette.mintForeground)
                            .matchedGeometryEffect(id: "client", in: detailAnimation)
                        Spacer()
                        Text("\(String(format: "%.1f", workday.hours)) hrs")
                            .font(.title.bold())
                            .padding()
                            .foregroundColor(JaffPalette.mintForeground)
                            .matchedGeometryEffect(id: "hours", in: detailAnimation)
                    }
                    
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(JaffPalette.midGreen))
                    .padding(.horizontal)
                    .matchedGeometryEffect(id: "background", in: detailAnimation)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showingDetails.toggle()
                        }
                    }
                }
            
            } else {
                
                if (!inEditMode) {
                    
                    Group {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(clientName)
                                    .font(.title.bold())
                                    .padding()
                                    .foregroundColor(JaffPalette.mintForeground)
                                    .matchedGeometryEffect(id: "client", in: detailAnimation)
                                Spacer()
                                Text("\(String(format: "%.1f", workday.hours)) hrs")
                                    .font(.title.bold())
                                    .padding()
                                    .foregroundColor(JaffPalette.mintForeground)
                                    .matchedGeometryEffect(id: "hours", in: detailAnimation)
                            }
                            HStack {
                                Text("\(model.timeFormatter.string(from: workday.startTime)) - \(model.timeFormatter.string(from: workday.endTime))")
                                    .font(.title2.bold())
                                    .padding(.horizontal)
                                    .foregroundColor(JaffPalette.mintForeground)
                                Spacer()
                                
                            }
                            Text(workday.tasks)
                                .foregroundColor(JaffPalette.mintForeground)
                                .padding(.horizontal)
                            
                            ForEach(workday.expenses, id: \.id) { expense in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(expense.name)
                                            .bold()
                                            .foregroundColor(JaffPalette.mintForeground)
                                        Text("-")
                                            .bold()
                                            .padding(.horizontal, 3)
                                            .foregroundColor(JaffPalette.mintForeground)
                                        Text("$\(String(format: "%.2f", expense.amount))")
                                            .bold()
                                            .foregroundColor(JaffPalette.mintForeground)
                                        
                                    }
                                    Text(expense.description)
                                        .foregroundColor(JaffPalette.mintForeground)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                
                            }
                            
                            Text(workday.notes)
                                .padding()
                                .foregroundColor(JaffPalette.mintForeground)
                            
                            HStack {
                                Spacer()
                                Button {
                                    if (!inEditMode) {
                                        workdayData = workday.data
                                    }
                                    if (inEditMode) {
                                        workday.update(from: workdayData)
                                    }
                                    inEditMode.toggle()
                                } label: {
                                    Image(systemName: inEditMode ? "lock.open.fill" : "lock.fill")
                                        .font(.body.weight(.bold))
                                        .foregroundColor(Color.yellow)
                                        .padding(10)
                                        .background(.black, in: RoundedRectangle(cornerRadius: 30))
                                }
                                .padding()
                                Spacer()
                            }
                        }
                        .transition(.opacity) // TODO: this looks just a bit cleaner
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(JaffPalette.midGreen))
//                        .matchedGeometryEffect(id: "background", in: detailAnimation)
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showingDetails.toggle()
                            }
                        }
                    }
                    
                } else {
                    
                    // TODO: EDIT MODE
                    
                    
                    VStack(alignment: .leading) {
                        
                        Group {
                            Text(clientName)
                                .font(.title.bold())
                                .padding()
                                .foregroundColor(JaffPalette.mintForeground)
                                .matchedGeometryEffect(id: "client", in: detailAnimation)
                            
                            HStack {
                                
                                Text("Date:")
                                    .bold()
                                    .foregroundColor(JaffPalette.mintForeground)
                                    .padding(.leading)
                                
                                DatePicker("Date", selection: $workdayData.date, displayedComponents: .date)
                                    .font(.title2.bold())
                                    .labelsHidden()
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green))
                                    .padding(.trailing)
                                
                            }
                            
                            HStack {
                                
                                Text("Start:")
                                    .bold()
                                    .padding(.leading)
                                    .foregroundColor(JaffPalette.mintForeground)
                                
                                DatePicker("Date", selection: $workdayData.startTime, displayedComponents: .hourAndMinute)
                                    .font(.title2.bold())
                                    .labelsHidden()
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green))
                                
                                
                                Text("End:")
                                    .bold()
                                    .padding(.leading)
                                    .foregroundColor(JaffPalette.mintForeground)
                                
                                DatePicker("Date", selection: $workdayData.endTime, displayedComponents: .hourAndMinute)
                                    .font(.title2.bold())
                                    .labelsHidden()
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                                        LinearGradient(colors: [.green, .green], startPoint: .topLeading, endPoint: .bottomTrailing)))
                                    .padding(.trailing)
                            }
                        }
                        
                        Group {
                            
                            Text("Tasks")
                                .bold()
                                .padding(.horizontal)
                                .padding(.top)
                                .foregroundColor(JaffPalette.mintForeground)
                            TextEditor(text: $workdayData.tasks)
                                .font(.body)
                                .colorMultiply(Color.green)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                                .padding(.horizontal)
                            
                        }
                        
                        Text("Expenses")
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)
                            .foregroundColor(JaffPalette.mintForeground)
                    
                        
                        ForEach($workdayData.expenses) { $expense in
                        
                            ExpenseRow(workdayData: $workdayData, expense: $expense)
                                .environmentObject(model)
                        }
                        if (addingPayee) {
                            HStack {
                                TextField("New Payee Name", text: $newPayeeName)
                                    .accentColor(.black)
                                    .padding()
                                    .transition(.opacity)
                                
                                Button(action: {
                                    model.addPayee(name: newPayeeName)
                                    newPayeeName = ""
                                    withAnimation {
                                        addingPayee.toggle()
                                    }
                                }) {
                                    Text("Confirm Add")
                                        .foregroundColor(Color.yellow)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(Color.black)
                                        .cornerRadius(20)
                                        .transition(.opacity)
                                }
                                .padding(.trailing)
                            }
                            .background(Color.yellow)
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    workdayData.addNewExpense()
                                }
                            }) {
                                Text("+ Expense")
                                    .foregroundColor(Color.yellow)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.black)
                                    .cornerRadius(20)
                            }
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    addingPayee.toggle()
                                }
                            }) {
                                if (addingPayee) {
                                    Text("Cancel New Payee")
                                        .foregroundColor(Color.yellow)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(Color.black)
                                        .cornerRadius(20)
                                        .transition(.opacity)
                                } else {
                                    Text("+ Payee")
                                        .foregroundColor(Color.yellow)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(Color.black)
                                        .cornerRadius(20)
                                        .transition(.opacity)
                                }
                            }
                            Spacer()
                        }
                        
                        Text("Notes")
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)
                            .foregroundColor(JaffPalette.mintForeground)
                        TextEditor(text: $workdayData.notes)
                            .font(.body)
                            .colorMultiply(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .frame(height: 80)
                        
                        HStack {
                            Spacer()
                            Button {
                                if (!inEditMode) {
                                    workdayData = workday.data
                                }
                                if (inEditMode) {
                                    if (workdayData.endTime < workdayData.startTime) {
                                        showInvalidHoursMessage.toggle()
                                    } else {
                                        workday.update(from: workdayData)
                                    }
                                }
                                withAnimation(.spring()) {
                                    inEditMode.toggle()
                                }
                                
                            } label: {
                                Image(systemName: inEditMode ? "lock.open.fill" : "lock.fill")
                                    .font(.body.weight(.bold))
                                    .foregroundColor(Color.yellow)
                                    .padding(10)
                                    .background(.black, in: RoundedRectangle(cornerRadius: 30))
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(JaffPalette.backgroundDark))
                    .transition(.opacity)
//                    .matchedGeometryEffect(id: "background", in: detailAnimation)
                    .padding(.horizontal)
            
                }
            }
        }
        .alert(isPresented: $showInvalidHoursMessage) {
            Alert(title: Text("Highly Doubtful that you stopped before you started... unless you're building a time machine?"))
        }
    }
    
}

struct WorkdayCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            WorkdayCard(clientName: "Alandar", workday: .constant(WorkDay.example))
                .environmentObject(ViewModel())
        }
    }
}
