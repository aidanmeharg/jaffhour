//
//  editTest.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-30.
//

import SwiftUI

struct editTest: View {
    
    @State var editmode = EditMode.inactive
    
    @State var things = ["first thing", "second thing", "third thing"]
    
    var body: some View {
        
        
        
        NavigationView {

            List {
                ForEach(things, id: \.self) { thing in
                    NavigationLink(destination: Text(thing), label: {
                        Text(thing)
                    })
                }
                .onDelete(perform: { _ in
                    things.remove(at: 0)
                })
                .onMove(perform: { indices, newOffset in })
            }
            .navigationTitle("Things")
            .navigationBarItems(trailing: EditButton())

            .environment(\.editMode, $editmode)

        } // end of navview
        
        
    }
}

struct editTest_Previews: PreviewProvider {
    static var previews: some View {
        editTest()
    }
}
