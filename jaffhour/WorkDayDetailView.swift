//
//  WorkDayDetailView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-06.
//

import SwiftUI

struct WorkDayDetailView: View {
    
    let workday: WorkDay
    
    let CORNER_RADIUS = CGFloat(25)
    
    private let dateformatter = DateFormatter()
    private let timeformatter = DateFormatter()
    
    init(workday: WorkDay) {
        self.workday = workday
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .none // don't really need the dateformatter, just time
        timeformatter.dateStyle = .none
        timeformatter.timeStyle = .short
    }
    
    var body: some View {
        VStack {
            Text("\(timeformatter.string(from: workday.startTime)) to \(timeformatter.string(from: workday.endTime))")
                .padding(.top)
            Text("\(String(format: "%.2f", workday.hours)) hours")
                .padding(.bottom)
            Text("\(workday.tasks)")
                .multilineTextAlignment(.leading)
                .padding(.bottom)
                .padding(.horizontal)
            VStack {
                ForEach(workday.expenses, id: \.id) { expense in
                    HStack {
                        Text("\(expense.name)")
                            .padding(.horizontal)
                        Spacer()
                        Text("\(expense.description)")
                            .multilineTextAlignment(.leading) // is this even doing anything??
                            .padding(.top)
                        Spacer()
                        Text("$\(String(format: "%.2f", expense.amount))")
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                HStack {
                    Spacer()
                    let amounts = workday.expenses.map { $0.amount }
                    Text("$\(String(format: "%.2f", amounts.reduce(0, +)))")
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            Text("\(workday.notes)")
                .padding(.bottom)
            
        }
        .background(RoundedRectangle(cornerRadius: CORNER_RADIUS).foregroundColor(.green))
        .padding(.horizontal)
    }
}


struct WorkDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkDayDetailView(workday: WorkDay.example)
    }
}
