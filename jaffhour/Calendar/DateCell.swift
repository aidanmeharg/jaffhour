//
//  DateCell.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-23.
//

import SwiftUI

struct DateCell: View {
    
    var namespace: Namespace.ID
    
    @EnvironmentObject var model: ViewModel
    
    @EnvironmentObject var dateHolder: DateHolder
    
    @Binding var showingDayDetails: Bool
    
    var date: Date
    
    @Binding var dateForDetailView: Date
    
    var body: some View {
        
        // idea: use month-day-year to give each bubble its own unique id
        ZStack {
            Text("\(model.dayOfWeekFormatter.string(from: date)) \n \(model.monthFormatter.string(from: date))")
                .foregroundColor(Color.clear)
                .matchedGeometryEffect(id: "DayOfWeek\(model.mdyFormatter.string(from: date))", in: namespace)
            Text(model.yearFormatter.string(from: date))
                .foregroundColor(Color.clear)
                .matchedGeometryEffect(id: "Year\(model.mdyFormatter.string(from: date))", in: namespace)
            Circle()
                .strokeBorder(lineWidth: 7)
                .foregroundColor(circleColor())
                .padding(.horizontal, 2)
                .matchedGeometryEffect(id: "DayCircle\(model.mdyFormatter.string(from: date))", in: namespace)
                .frame(width: 55)
                .frame(maxHeight: .infinity)
            Text(model.dayFormatter.string(from: date))
                .foregroundColor(getDayColour())
                .font(.title3.bold())
                .matchedGeometryEffect(id: "Day\(model.mdyFormatter.string(from: date))", in: namespace)
        }
        .onTapGesture {
            dateForDetailView = date
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showingDayDetails.toggle()
            }
        }
    }
    
    
    
    
    func getDayColour() -> Color {
        var inSameMonth = true
        if (model.monthFormatter.string(from: dateHolder.date) != model.monthFormatter.string(from: date)) {
            inSameMonth = false
        }
        return inSameMonth ? Color.black : Color.gray
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black : Color.gray
    }
    
    func circleColor() -> Color {
        let littleToFour = Color(red: 156/255, green: 233/255, blue: 172/255)
        let FourToEight = Color(red: 68/255, green: 196/255, blue: 106/255)
        let EightPlus = Color(red: 51/255, green: 161/255, blue: 83/255)
        
        let isToday = CalendarHelper().isToday(date: date)
        var hoursWorked = 0.0
        for job in model.jobs {
            for wd in job.workdays { // use reversed because much more likely that calendar will be displaying most recent workdays
                if wd.date < date {
                    break
                }
                if Calendar.current.isDate(wd.date, equalTo: date, toGranularity: .day) {
                    hoursWorked += wd.hours
                    break
                }
            }
        }
        var col = Color.clear
        if (hoursWorked > 0.0 && hoursWorked < 4.0) {
            col = littleToFour
        }
        if (hoursWorked >= 4.0 && hoursWorked < 8.0) {
            col = FourToEight
        }
        if (hoursWorked >= 8.0) {
            col = EightPlus
        }
        return isToday ? Color.red : col
    }
    
}

struct DateCell_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        DateCell(namespace: namespace, showingDayDetails: .constant(false), date: Date(), dateForDetailView: .constant(Date()))
            .environmentObject(DateHolder())
            .environmentObject(ViewModel())
    }
}
