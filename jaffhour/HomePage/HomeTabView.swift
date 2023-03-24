//
//  HomeTabView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-25.
//

import SwiftUI

struct HomeTabView: View {
    
    @StateObject var model = ViewModel()
    
    @State private var selectedTab = "calendar"
    
    private let dateHolder = DateHolder()
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            MonthView()
                .environmentObject(model)
                .environmentObject(dateHolder)
                .tabItem {
                    Label("calendar", systemImage: "calendar")
                }
                .tag("calendar")
            
            NavigationView {
                ContentView(model: model)
            }
                .tabItem {
                    Label("clients", systemImage: "person.3")
                }
                .tag("clients")
            
        }
        //.scrollContentBackground(.hidden)
//        .background(Color.green)
    }
    
    struct HomeTabView_Previews: PreviewProvider {
        static var previews: some View {
            HomeTabView()
        }
    }
}
