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
    
    @State private var selectedPayee = ""
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        VStack {
            DateIcon()
            Text("gonna remake the app to get this to work")
        }
    }
}

struct EditPayeesView_Previews: PreviewProvider {
    static var previews: some View {
        EditPayeesView()
    }
}
