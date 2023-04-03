//
//  addExpenseView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-06.
//

import SwiftUI

// Custom row view for addWorkDayView expenses list
struct addExpenseView: View {
    
    @EnvironmentObject var model: ViewModel
    
    var globalpayees = GlobalPayees.sharedInstance
    
    @Binding var expense: Expense
    
    @State private var selectedName = ""
    
    @State private var newPayee = false
    
    func updatePayee() {
        expense.name = selectedName
    }
    
    var body: some View {
        
            VStack {

                Toggle("New Payee", isOn: $newPayee)
                    .padding(.all)
                    .buttonStyle(BorderlessButtonStyle())
                    .tint(.yellow)
                if newPayee {

                    HStack {
                        TextEditor(text: $selectedName)
                            .font(.body)
                            .colorMultiply(Color.purple)
                            .cornerRadius(10)
                            .frame(height: 80)
                        Button {
                            if (selectedName != "") {
                                globalpayees.addPayee(payee: selectedName) // TODO: get rid of globalpayees
                                model.payees.append(selectedName)
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

                        Picker("Payable to: ", selection: $selectedName) {

                            ForEach(model.payees, id: \.self) { //payee in
                                Text($0)
                            }
                            .onChange(of: selectedName) { newValue in
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
                .environmentObject(ViewModel())
        }
    }
}
