//
//  ExpenseRowView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-06.
//

import SwiftUI

struct ExpenseRowView: View {
    
    @Binding var expense: Expense
    
    var body: some View {
        Text("\(expense.name) : $\(String(format: "%.2f", round(expense.amount * 100) / 100.0))")
    }
}

struct ExpenseRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRowView(expense: .constant(Expense.example1))
    }
}
