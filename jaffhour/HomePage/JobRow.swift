//
//  JobRow.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-29.
//

import SwiftUI

struct JobRow: View {
    
    @EnvironmentObject var model: ViewModel
    
    @Binding var job: Job
    
    var body: some View {
        
        NavigationLink {
            JobView(job: $job)
                .environmentObject(model)
        } label: {
            HStack {
                Image(systemName: "folder.circle")
                    .foregroundColor(.yellow)
                Text(job.title)
                    .foregroundColor(JaffPalette.mintForeground)
            }
        }
        //.listRowBackground(Color.gray)
        .tag(job)
    }
}

struct JobRow_Previews: PreviewProvider {
    
    static var previews: some View {
        JobRow(job: .constant(Job.example))
            .environmentObject(ViewModel())
    }
}


