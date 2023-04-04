//
//  EditPayeesView.swift
//  jaffhour
//
//  Created by Aidan on 2022-11-23.
//

import SwiftUI

struct EditPayeesView: View {
    
    @EnvironmentObject var model: ViewModel
    
    @State private var showingAddSheet: Bool = false
    
    @State private var newPayeeName: String = ""
    
    @State private var selectedPayees: Set<String> = []
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        VStack {
            List(selection: $selectedPayees) {
                ForEach($model.payees, id: \.self) { $payee in
                    Text(payee)
                        .tag(payee)
                        .foregroundColor(JaffPalette.mintForeground)
                        .listRowBackground(JaffPalette.midGreen)
                }
                .onMove(perform: model.movePayees)
            }
        }
        .scrollContentBackground(.hidden)
        .background(JaffPalette.backgroundDark)
        .sheet(isPresented: $showingAddSheet) {
            ZStack {
                JaffPalette.backgroundDark
                    .ignoresSafeArea()
                HStack {
                    TextField("New Payee Name", text: $newPayeeName)
                        .accentColor(.black)
                        .padding()
                    
                    Button(action: {
                        model.addPayee(name: newPayeeName)
                        newPayeeName = ""
                        showingAddSheet.toggle()
                    }) {
                        Text("Confirm Add")
                            .foregroundColor(Color.yellow)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.black)
                            .cornerRadius(20)
                    }
                }
                .padding(.vertical)
                .background(Color.yellow)
            }
                
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .padding()
                    .disabled(model.payees.isEmpty)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddSheet.toggle()
                } label: {
                    Label("Add New Payee", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {         
                Button(role: .destructive) {
                    model.deletePayees(selectedPayees)
                    selectedPayees.removeAll()
                    editMode = .inactive
                } label: {
                    Label("Delete Selected", systemImage: "trash")
                        
                }
                .disabled(selectedPayees.isEmpty || editMode == .inactive)
                        
                        
                    
                
            }
        }
        .environment(\.editMode, $editMode)
    }
}

struct EditPayeesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPayeesView()
                .environmentObject(ViewModel())
        } 
    }
}
