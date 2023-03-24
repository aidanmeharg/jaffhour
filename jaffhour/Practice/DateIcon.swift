//
//  DateIcon.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-20.
//
// TODO: rewrite tha whole damn app!
// -> use single source of truth (use state and binding properly)
// -> make a Data struct (extension for Workday) so we can edit easily and then save changes to workday list
// -> make sick transitions
// -> contribution calendar should reflect hours worked not # of jobs <>

import SwiftUI

struct DateIcon: View {
    
    @State var showingDetailView: Bool = false
    @Namespace var namespace
    
    let day: Int = 21
    
    var body: some View {
        
        ZStack {
            if !showingDetailView {
                ZStack {
                    Circle()
                        .strokeBorder(lineWidth: 30)
                        .foregroundColor(Color.pink)
                        .padding(10)
                        .matchedGeometryEffect(id: "Circle", in: namespace)
                        .frame(width: 150, height: 150)
                    
                    Text("Monday March")
                        .foregroundColor(Color.clear)
                        .matchedGeometryEffect(id: "MonthText", in: namespace)
                    
                    Text("2023")
                        .foregroundColor(Color.clear)
                        .matchedGeometryEffect(id: "YearText", in: namespace)
                        
                    Text(String(day))
                        .font(.title.bold())
                        .matchedGeometryEffect(id: "Day", in: namespace)
                }
            
    
            } else {
                DateDetailView(namespace: namespace, day: day, showingDetailView: $showingDetailView)
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showingDetailView.toggle()
            }
        }
    }
}

struct DateIcon_Previews: PreviewProvider {
    static var previews: some View {
        DateIcon()
    }
}
