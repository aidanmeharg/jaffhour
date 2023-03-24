//
//  DateDetailView.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-21.
//

import SwiftUI

struct DateDetailView: View {
    
    var namespace: Namespace.ID
    var day: Int
    @Binding var showingDetailView: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                dateHeader
            }
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showingDetailView.toggle()
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
    }
    
    var dateHeader: some View {
        HStack {
            Text("Monday March")
                .font(.title.bold())
                .padding(.leading)
                .matchedGeometryEffect(id: "MonthText", in: namespace)
            ZStack {
                Circle()
                    .foregroundColor(Color.green)
                    .padding(10)
                    .matchedGeometryEffect(id: "Circle", in: namespace)
                    .frame(width: 100, height: 100)
                
                Text(String(day))
                    .font(.title.bold())
                    .matchedGeometryEffect(id: "Day", in: namespace)
            }
            Text("2023")
                .font(.title.bold())
                .padding(.trailing)
                .matchedGeometryEffect(id: "YearText", in: namespace)
        }
    }
}

struct DateDetailView_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        DateDetailView(namespace: namespace, day: 21, showingDetailView: .constant(true))
    }
}
