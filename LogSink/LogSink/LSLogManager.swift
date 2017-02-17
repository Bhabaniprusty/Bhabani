//
//  LSLogManager.swift
//  LogSink
//
//  Created by Bhabani on 16/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation

class LSLogManager {
    
    private var logSink: LSLogSink!
    static let sharedInstance: LSLogManager = LSLogManager()
    
    private init() {
        logSink = LSConfiguration().prepareLogSink()
    }
    
    func log(eventType: String, eventTitle: String, eventDetail: [String : String]?){
        logSink.log(eventType: eventType, eventTitle: eventTitle, eventDetail: eventDetail)
    }
}

protocol LSLogSink {
    func log(eventType: String, eventTitle: String, eventDetail: [String : String]?)
}
