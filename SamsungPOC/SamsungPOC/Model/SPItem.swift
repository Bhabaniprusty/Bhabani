//
//  SPItem.swift
//  SamsungPOC
//
//  Created by Bhabani on 24/04/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SPItem {
    let imageUrl: String
    
    init?(json: JSON) {
        guard let imageUrl = json["url"].string else { return nil }
        
        self.imageUrl = imageUrl
    }
}



