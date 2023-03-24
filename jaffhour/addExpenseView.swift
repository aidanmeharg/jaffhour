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
                    .buttonStyle(BorderlessButtonStyle())
                if newPayee {
                    
                    HStack {
                        TextEditor(text: $selectedPayee)
                            .padding(.all)
                        Button {
                            if (selectedPayee != "") { 
                                globalpayees.addPayee(payee: selectedPayee)
                                updatePayee()
                                newPayee = false
                            }
                        } label: {
                            Label("add to payees", systemImage: "plus")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                    
                } else {
                    
                    VStack {
                        
                        Picker("Payable to: ", selection: $selectedPayee) {
                            
                            ForEach(globalpayees.payees, id: \.self) { //payee in
                                Text($0)
                            }
                            .onChange(of: selectedPayee) { newValue in
                                updatePayee()
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.all)
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                    
                    TextField("Description", text: $expense.description)
                        .padding(.all)
                        .buttonStyle(BorderlessButtonStyle())
                    
                    TextField("Amount", value: $expense.amount, format: .currency(code: "CAD"))
                        .keyboardType(.decimalPad)
                        .padding(.all)
                        .buttonStyle(BorderlessButtonStyle())
                    
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
