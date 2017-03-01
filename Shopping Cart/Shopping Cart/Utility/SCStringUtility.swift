//
//  SCStringUtility.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation

extension String{
    
    func dateValue() -> NSDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"
        return dateFormatter.date(from: self) as NSDate?
    }
}
