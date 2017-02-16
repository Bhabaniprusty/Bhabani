//
//  LSLogManager.swift
//  LogSink
//
//  Created by Bhabani on 16/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation

typealias evalFunc = (String)->LSLogSink

let generateObject: evalFunc = {classname -> LSLogSink in
    let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
    let className = appName+"."+classname
    return (NSClassFromString(className) as! NSObject.Type).init() as! LSLogSink
}

class LSLogManager {
    
    private var logSink: LSLogSink!
    static let sharedInstance: LSLogManager = LSLogManager()
    
    private init() {
        
        if let logType = getLogTypeFromConfiguration() {
            logSink = logSink(action: logType)
        }
    }
    

    private func getLogTypeFromConfiguration() -> String?{
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let configuration = NSDictionary(contentsOfFile: path),
            let logType = configuration["logType"] as? String else{
            
            return nil;
        }
        
        return logType
    }
    
    private enum LSLogType {
        case Console(evalFunc)
        case Database(evalFunc)
        case File(evalFunc)
    }
    
    func log(eventType: String, eventTitle: String, eventDetail: [String : String]?){
        logSink.log(eventType: eventType, eventTitle: eventTitle, eventDetail: eventDetail)
    }
    
    private var logOption: Dictionary<String, LSLogType> = [
        "📕" : .Console{generateObject($0)},
        "📗" : .Database{generateObject($0)},
        "📒" : .File{generateObject($0)}
    ]
    
    private func logSink(action: String)->LSLogSink {
        var logSink: LSLogSink!
        if let logType =  logOption[action]{
            switch logType {
            case .Console(let funnction):
                logSink = funnction("LSConsole")
            case .Database(let funnction):
                logSink =  funnction("LSDataBase")
            case .File(let funnction):
                logSink =  funnction("LSFile")
            }
        }
        
        return logSink
    }
}

protocol LSLogSink {
    func log(eventType: String, eventTitle: String, eventDetail: [String : String]?)
}
