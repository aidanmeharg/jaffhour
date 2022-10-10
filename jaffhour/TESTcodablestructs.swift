//
//  TESTcodablestructs.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-09.
//

import Foundation

struct testday: Codable {
    var id = UUID()
    var description: String
    var date: Date
    //var dateform: DateFormatter = DateFormatter()
}
