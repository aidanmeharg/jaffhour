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
            ScrollView {
                dateHeader
            }
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
                       .foregroundColor(Color.green)
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
