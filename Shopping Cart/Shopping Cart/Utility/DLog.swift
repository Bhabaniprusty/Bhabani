//
//  DLog.swift
//  Shopping Cart
//
//  Created by Bhabani on 01/03/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
struct Log {
    
    static func DLog(_ message: String, function: String = #function) {
        #if DEBUG
            print("\(function): \(message)")
        #endif
    }
}
