//
//  jaffhourApp.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-27.
//

import SwiftUI

@main
struct jaffhourApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            // Ensures time and wifi widgets remain viewable
            NavigationView {
                ContentView()
            }
        }
    }
}
