//
//  MonthScrollerView.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-20.
//

import SwiftUI

struct MonthScrollerView: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: previousMonth) {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(.title.bold())
            }
            Text(CalendarHelper().monthYearString(date: dateHolder.date))
                .foregroundColor(JaffPalette.mintForeground)
                .font(.title.bold())
                .frame(maxWidth: .infinity)
            Button(action: nextMonth) {
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .font(.title.bold())
            }
            Spacer()
        }
    }
    
    func previousMonth() {
        dateHolder.date = CalendarHelper().decMonth(date: dateHolder.date)
    }
    
    func nextMonth() {
        dateHolder.date = CalendarHelper().incMonth(date: dateHolder.date)
    }
}

struct MonthScrollerView_Previews: PreviewProvider {
    static var previews: some View {
        MonthScrollerView()
            .environmentObject(DateHolder())
    }
}
