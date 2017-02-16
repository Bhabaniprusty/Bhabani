//
//  LSFile.swift
//  LogSink
//
//  Created by Bhabani on 16/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation


class LSFile: LSLogBase, LSLogSink {
    
    func log(eventType: String, eventTitle: String, eventDetail: [String : String]?){
        print("Log from \(self)")
    }
    

}
