//
//  ExpenseRow.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-26.
//

import SwiftUI

struct ExpenseRow: View {
    
    @EnvironmentObject var model: ViewModel
    
    @Binding var workdayData: WorkDay.Data
    
    @Binding var expense: Expense
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("To:")
                    .bold()
                    .padding(.leading)
                Menu {
                    Picker(selection: $expense.payee.name,
                           label: EmptyView(),
                           content: {
                        ForEach(model.payees) { payee in
                            Text(payee.name).tag(payee.name)
                        }
                    }).pickerStyle(.automatic)
                } label: {
                    Text(expense.payee.name)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(.green)
                        .cornerRadius(10)
                        .accentColor(Color.black)
                }
                Spacer()
                Button {
                    // delete dat expense (FROM TEMPORARY workdayData)
                    //
                    // be careful when doing this, don't wanna mess up all the views
                    //
                    // make an @ObservableObject class corresponding to temporary workdayData, add a function to delete from there??
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 50, height: 50)
                            
                        Image(systemName: "xmark")
                            .font(.title2)
                            .font(.body.weight(.bold))
                            .foregroundColor(.black)
                    }
                }.padding(.trailing)
            }
            HStack {
                Text("Amt:")
                    .bold()
                    .padding(.leading)
                
                TextField("Amount", value: $expense.amount, format: .currency(code: "CAD"))
                    .keyboardType(.decimalPad)
                    .accentColor(.black)
                    .frame(width: 135)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(.green)
                    .cornerRadius(10)
            }
            
            
            TextEditor(text: $expense.description)
                .font(.body)
                .colorMultiply(Color.purple)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .padding(.horizontal)
                
            
            Rectangle() // divider for expenses
                .frame(height: 3)
                .frame(maxWidth: .infinity)

        }
    }
}

struct ExpenseRow_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRow(workdayData: .constant(WorkDay.Data()), expense: .constant(Expense.example3))
            .environmentObject(ViewModel())
    }
}