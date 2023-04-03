//
//  DayDetailView.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-23.
//

import SwiftUI

struct DayDetailView: View {
    
    @Namespace var newWorkdayAnimation
    
    var namespace: Namespace.ID
    
    @EnvironmentObject var model: ViewModel
    
    @Binding var showingDayDetails: Bool
    
    @State var addingWorkday: Bool = false
    
    @State var selectedClient = ""
    
    @State var newClientName = ""
    
    var date: Date

    var body: some View {
        
        ZStack {
            LinearGradient(colors: [.green, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .matchedGeometryEffect(id: "background", in: namespace)
            ScrollView {
                
                VStack {
                    dateHeader
                        .padding(.all)
                    
                    ForEach($model.jobs) { $job in
                        ForEach($job.workdays) { $workday in
                            if (Calendar.current.isDate(date, equalTo: workday.date, toGranularity: .day)) {
                                WorkdayCard(clientName: job.title, workday: $workday)
                                    .environmentObject(model)
                            }
                        }
                    }
                    
                    if (addingWorkday) {
                        Menu {
                            Picker(selection: $selectedClient,
                                   label: EmptyView(),
                                   content: {
                                ForEach(model.jobs, id: \.title) { job in
                                    Text(job.title)
                                }
                            }).pickerStyle(.automatic)
                        } label: {
                            Text(selectedClient == "" ? "Select Client" : selectedClient)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(.green)
                                .cornerRadius(10)
                                .accentColor(Color.black)
                        }
                        HStack {
                            TextField("New Client Name", text: $newClientName)
                                .padding()
                            
                            Button(action: {
                                model.addJob(title: newClientName)
                                newClientName = ""
                            }) {
                                Text("Add New Client")
                                    .foregroundColor(Color.yellow)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.black)
                                    .cornerRadius(20)
                                    .transition(.opacity)
                            }
                            .padding(.trailing)
                        }
                        Button(action: {
                            if (selectedClient != "") {
                            
                                model.addWorkdayForClient(clientName: selectedClient, date: date)
                                
                                selectedClient = ""
                                withAnimation {
                                    addingWorkday.toggle()
                                }
                            }
                        }) {
                            Text(selectedClient == "" ? "No Client Selected" : "Add Day For \(selectedClient)")
                                .foregroundColor(Color.yellow)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.black)
                                .cornerRadius(20)
                                .transition(.opacity)
                        }
                    }

                    Button(action: {
                        withAnimation(.spring()) {
                            addingWorkday.toggle()
                        }
                    }) {
                        if (!addingWorkday) {
                            Text("+ Work Day")
                                .foregroundColor(Color.yellow)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.black)
                                .cornerRadius(20)
                                .matchedGeometryEffect(id: "add_cancelbutton", in: newWorkdayAnimation)
                        } else {
                            Text("Cancel New Day")
                                .foregroundColor(Color.yellow)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.black)
                                .cornerRadius(20)
                                .matchedGeometryEffect(id: "add_cancelbutton", in: newWorkdayAnimation)
                        }
                        
                    }
                }
            }
//            .scrollDismissesKeyboard(.automatic) TODO: add this back for jaff
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showingDayDetails.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.bold))
                    .foregroundColor(Color.yellow)
                    .padding(10)
                    .background(.black, in: Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .ignoresSafeArea()
        }
        .statusBarHidden(true)
        
        
    }
    
    var dateHeader: some View {
        HStack {
               Text("\(model.dayOfWeekFormatter.string(from: date)) \n \(model.monthFormatter.string(from: date))")
                   .font(.title.bold())
                   .padding(.leading)
                   .matchedGeometryEffect(id: "DayOfWeek\(model.mdyFormatter.string(from: date))", in: namespace)
                
               ZStack {
                   Circle()
                       .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing))
                       .padding(.horizontal, 2)
                       .matchedGeometryEffect(id: "DayCircle\(model.mdyFormatter.string(from: date))", in: namespace)
                       .frame(width: 100, height: 100)
                       
                   Text(model.dayFormatter.string(from: date))
                       .foregroundColor(Color.black)
                       .font(.title.bold())
                       .matchedGeometryEffect(id: "Day\(model.mdyFormatter.string(from: date))", in: namespace)
                      
               }
               Text(model.yearFormatter.string(from: date))
                   .font(.title.bold())
                   .padding(.trailing)
                   .matchedGeometryEffect(id: "Year\(model.mdyFormatter.string(from: date))", in: namespace)
                  
            }

    }
}

struct DayDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        DayDetailView(namespace: namespace, showingDayDetails: .constant(true), date: Date())
            .environmentObject(ViewModel())
    }
}
