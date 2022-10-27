//
//  HomeTabView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-25.
//

import SwiftUI

struct HomeTabView: View {
    
    @ObservedObject var model = ViewModel()
    
    @State private var selectedTab = "clients"
    
    private let dateHolder = DateHolder()
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            NavigationView {
                ContentView(model: model)
            }
                .tabItem {
                    Label("clients", systemImage: "person")
                }
                .tag("clients")
            
            MonthlyView(model: model)
                .environmentObject(dateHolder)
                .tabItem {
                    Label("calendar", systemImage: "calendar")
                }
                .tag("calendar")
        }
        //.scrollContentBackground(.hidden)
        .background(Color.green)
    }
    
    struct HomeTabView_Previews: PreviewProvider {
        static var previews: some View {
            HomeTabView()
        }
    }
}
