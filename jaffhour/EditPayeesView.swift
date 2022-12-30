//
//  EditPayeesView.swift
//  jaffhour
//
//  Created by Aidan on 2022-11-23.
//

import SwiftUI

struct EditPayeesView: View {
    
    var globalpayees = GlobalPayees.sharedInstance
    
    @State private var selectedPayees: Set<String> = []
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        Text("coming soon?")
    }
}

struct EditPayeesView_Previews: PreviewProvider {
    static var previews: some View {
        EditPayeesView()
    }
}
