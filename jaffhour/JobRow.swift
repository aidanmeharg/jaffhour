//
//  JobRow.swift
//  jaffhour
//
//  Created by Aidan on 2022-09-29.
//

import SwiftUI

struct JobRow: View {
    
    @Binding var job: Job
    
    var body: some View {
        
        NavigationLink {
            JobView(job: $job)
        } label: {
            Label(job.title, systemImage: "folder.circle")
        }
        //.listRowBackground(Color.gray)
        .tag(job)
    }
}

struct JobRow_Previews: PreviewProvider {
    
    static var previews: some View {
        JobRow(job: .constant(Job.example))
    }
}


