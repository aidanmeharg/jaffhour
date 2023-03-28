//
//  DayDetailView.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-23.
//

import SwiftUI

struct DayDetailView: View {
    
    var namespace: Namespace.ID
    
    @EnvironmentObject var model: ViewModel
    
    @Binding var showingDayDetails: Bool
    
    
    var date: Date

    var body: some View {
        
        ZStack {
            LinearGradient(colors: [.purple, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
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

                    Button {
                        // add a new workday
                    } label: {
                        Image(systemName: "plus")
                            .font(.body.weight(.bold))
                            .foregroundColor(Color.green)
                            .padding(10)
                            .background(.black, in: RoundedRectangle(cornerRadius: 30))
                    }
                    .frame(width: 200, height: 100)
                    .background(.ultraThinMaterial)
                }
            }
//            .scrollDismissesKeyboard(.automatic) TODO: use this for jaffs phone
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showingDayDetails.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.bold))
                    .foregroundColor(Color.green)
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
                       .foregroundStyle(LinearGradient(colors: [.green, .green], startPoint: .leading, endPoint: .trailing))
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
