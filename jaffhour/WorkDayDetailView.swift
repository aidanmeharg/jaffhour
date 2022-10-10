//
//  WorkDayDetailView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-06.
//

import SwiftUI

struct WorkDayDetailView: View {
    
    @Binding var workday: WorkDay
    
    var body: some View {
        VStack {
            Text("\(workday.dateFormatter.string(from: workday.date))")
            Text(workday.tasks)
            Text(workday.notes)
            ForEach(workday.expenses, id: \.id) { expense in
                Text(expense.name)
                Text(expense.description)
                Text("\(expense.amount)")
            }
        }
    }
}

struct WorkDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkDayDetailView(workday: .constant(WorkDay.example))
    }
}
