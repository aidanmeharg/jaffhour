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
            
            Rectangle() // divider for expenses
                .frame(height: 3)
                .frame(maxWidth: .infinity)
            
            HStack {
                Text("To:   ")
                    .bold()
                    .padding(.leading)
                Menu {
                    Picker(selection: $expense.name,
                           label: EmptyView(),
                           content: {
                        ForEach(model.payees, id: \.self) { payee in
                            Text(payee) // .tag(payee)
                        }
                    }).pickerStyle(.automatic)
                } label: {
                    Text(expense.name)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(.green)
                        .cornerRadius(10)
                        .accentColor(Color.black)
                }
                Spacer()
                Button {
                    workdayData.deleteExpense(selected: expense)
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                            
                        Image(systemName: "xmark")
                            .font(.callout.bold())
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
                .colorMultiply(Color.green)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .padding(.horizontal)
                
            
            Rectangle() // divider for expenses
                .frame(height: 3)
                .frame(maxWidth: .infinity)

        }
        .background(.yellow.opacity(0.3))
        .transition(.opacity)
    }
}

struct ExpenseRow_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRow(workdayData: .constant(WorkDay.Data()), expense: .constant(Expense.example3))
            .environmentObject(ViewModel())
    }
}
