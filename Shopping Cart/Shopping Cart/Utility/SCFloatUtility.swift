//
//  SCFloatUtility.swift
//  Shopping Cart
//
//  Created by Bhabani on 25/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation

extension Float {
    var asLocaleCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self))!
    }
}
