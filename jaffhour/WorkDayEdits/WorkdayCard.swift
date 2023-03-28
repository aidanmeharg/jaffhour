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
    
    var body: some View {
        
        ZStack {
            if (!showingDetails) {
                Group {
                    HStack {
                        Text(clientName)
                            .font(.title.bold())
                            .padding()
                            .foregroundColor(Color.black)
                            .matchedGeometryEffect(id: "client", in: detailAnimation)
                        Spacer()
                        Text("\(String(format: "%.1f", workday.hours)) hrs")
                            .font(.title.bold())
                            .padding()
                            .matchedGeometryEffect(id: "hours", in: detailAnimation)
                    }
                    
                    .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(
                        LinearGradient(colors: [.purple, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)))
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
                                    .foregroundColor(Color.black)
                                    .matchedGeometryEffect(id: "client", in: detailAnimation)
                                Spacer()
                                Text("\(String(format: "%.1f", workday.hours)) hrs")
                                    .font(.title.bold())
                                    .padding()
                                    .matchedGeometryEffect(id: "hours", in: detailAnimation)
                            }
                            HStack {
                                Text("\(model.timeFormatter.string(from: workday.startTime)) - \(model.timeFormatter.string(from: workday.endTime))")
                                    .font(.title2.bold())
                                    .padding(.horizontal)
                                Spacer()
                                
                            }
                            Text(workday.tasks)
                                .padding(.horizontal)
                            
                            ForEach(workday.expenses, id: \.id) { expense in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(expense.payee.name)
                                            .bold()
                                        Text("-")
                                            .bold()
                                            .padding(.horizontal, 3)
                                        Text("$\(String(format: "%.2f", expense.amount))")
                                            .bold()
                                        
                                    }
                                    Text(expense.description)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                
                            }
                            
                            Text(workday.notes)
                                .padding()
                            
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
                                        .foregroundColor(Color.green)
                                        .padding(10)
                                        .background(.black, in: RoundedRectangle(cornerRadius: 30))
                                }
                                .padding()
                                Spacer()
                            }
                        }
                        
                        .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(
                            LinearGradient(colors: [.purple, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)))
                        .matchedGeometryEffect(id: "background", in: detailAnimation)
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
                                .foregroundColor(Color.black)
                                .matchedGeometryEffect(id: "client", in: detailAnimation)
                            
                            HStack {
                                
                                Text("Date:")
                                    .bold()
                                    .padding(.leading)
                                
                                DatePicker("Date", selection: $workdayData.date, displayedComponents: .date)
                                    .font(.title2.bold())
                                    .labelsHidden()
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                                        LinearGradient(colors: [.green, .green], startPoint: .topLeading, endPoint: .bottomTrailing)))
                                    .padding(.trailing)
                                
                            }
                            
                            HStack {
                                
                                Text("Start:")
                                    .bold()
                                    .padding(.leading)
                                
                                DatePicker("Date", selection: $workdayData.startTime, displayedComponents: .hourAndMinute)
                                    .font(.title2.bold())
                                    .labelsHidden()
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                                        LinearGradient(colors: [.green, .green], startPoint: .topLeading, endPoint: .bottomTrailing)))
                                
                                
                                Text("End:")
                                    .bold()
                                    .padding(.leading)
                                
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
                            TextEditor(text: $workdayData.tasks)
                                .font(.body)
                                .colorMultiply(Color.purple)
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .frame(height: 80)
                            
                        }
                        
                        Text("Expenses")
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)
                    
                        
                        ForEach($workdayData.expenses) { $expense in
                        
                            ExpenseRow(workdayData: $workdayData, expense: $expense)
                                .environmentObject(model)
                        }
                        
                        Text("Notes")
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)
                        TextEditor(text: $workdayData.notes)
                            .font(.body)
                            .colorMultiply(Color.purple)
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
                                    workday.update(from: workdayData)
                                }
                                withAnimation(.spring()) {
                                    inEditMode.toggle()
                                }
                                
                            } label: {
                                Image(systemName: inEditMode ? "lock.open.fill" : "lock.fill")
                                    .font(.body.weight(.bold))
                                    .foregroundColor(Color.green)
                                    .padding(10)
                                    .background(.black, in: RoundedRectangle(cornerRadius: 30))
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    
                    .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(
                        LinearGradient(colors: [.purple, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .matchedGeometryEffect(id: "background", in: detailAnimation)
                    .padding(.horizontal)
            
                }
            }
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
