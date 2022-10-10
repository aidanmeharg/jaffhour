//
//  WorkDayDetailView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-06.
//

import SwiftUI

struct WorkDayDetailView: View {
    
    @Binding var workday: WorkDay
    
    private let dateformatter = DateFormatter()
    
    init(workday: Binding<WorkDay>) {
        self._workday = workday
        dateformatter.dateFormat = "dd/MM/yyyy"
    }
    
    var body: some View {
        VStack {
            Text("\(dateformatter.string(from: workday.date))")
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
