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
    
    init(payees: [String] = [""]) {
        self.payees = payees
    }
    
    // TODO: should update to check for duplicates
    func addPayee(payee: String) {
        payees.append(payee)
    }
}
