//
//  LSLogUtill.swift
//  LogSink
//
//  Created by Bhabani on 16/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation


class LSLogUtill {
    
    class func log(eventType: String, eventTitle: String, eventDetail: [String : String]?){
        LSLogManager.sharedInstance.log(eventType: eventType, eventTitle: eventTitle, eventDetail: eventDetail)
    }
    
}
