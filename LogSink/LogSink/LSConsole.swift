//
//  LSConsole.swift
//  LogSink
//
//  Created by Bhabani on 16/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation


class LSConsole: LSLogBase, LSLogSink {
  
    func log(eventType: String, eventTitle: String, eventDetail: [String : String]?){
        print("Log from \(self)")

        print("Event type : \(eventType)")
        print("     Event title : \(eventTitle)")
        print("     Event detail : \(eventDetail)")
    }

}
