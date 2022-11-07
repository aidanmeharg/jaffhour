//
//  GlobalPayees.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-07.
//

import Foundation

// Singleton design pattern to hold payees for all jobs
final class GlobalPayees {
    
    var payees: [String]
    
    static let sharedInstance: GlobalPayees = {
        let instance = GlobalPayees()
        // setup code
        
        return instance
    }()
    
    init(payees: [String] = []) {
        self.payees = payees
    }
    
    func addPayee(payee: String) {
        payees.append(payee)
        if (Set(payees).count == payees.count) { // not a great implementation in terms of space usage but the payee lists aren't going to be huge
            return // no duplicates
        } else {
            payees.removeLast()
        }
    }
}
