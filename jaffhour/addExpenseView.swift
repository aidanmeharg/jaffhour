//
//  addExpenseView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-06.
//

import SwiftUI

// Custom row view for addWorkDayView expenses list
struct addExpenseView: View {
    
    var globalpayees = GlobalPayees.sharedInstance
    
    @Binding var expense: Expense
    
    @State private var selectedPayee = ""
    
    @State private var newPayee = false
    
    func updatePayee() {
        expense.name = selectedPayee
    }
    
    var body: some View {
            VStack {
                
                Toggle("New Payee", isOn: $newPayee)
                    .padding(.all)
                if newPayee {
                    
                    HStack {
                        TextField("Payee Name", text: $selectedPayee)
                            .padding(.all)
                        Button {
                            globalpayees.addPayee(payee: selectedPayee)
                            updatePayee()
                            newPayee = false
                        } label: {
                            Label("add to payees", systemImage: "plus")
                        }
                    }
                    
                    
                } else {
                    
                    // Obviously theres no link between selectedPayee and expense.name
                    Picker("Payable to: ", selection: $selectedPayee) {
                        ForEach(globalpayees.payees, id: \.self) { //payee in
                            Text($0)
                        }
                        .onChange(of: selectedPayee) { newValue in
                            updatePayee()
                        }
                    }
                    .padding(.all)
                    
                    
                    TextField("Description", text: $expense.description)
                        .padding(.all)
                    
                    TextField("Amount", value: $expense.amount, format: .currency(code: "CAD"))
                        .keyboardType(.decimalPad)
                        .padding(.all)
                    
                }
                
                    
            } // end of VStack
            
    }
}

struct addExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            addExpenseView(expense: .constant(Expense(name: "", description: "", amount: 0)))
        }
    }
}
