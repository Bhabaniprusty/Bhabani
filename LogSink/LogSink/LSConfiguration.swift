//
//  LSConfiguration.swift
//  LogSink
//
//  Created by Bhabani on 17/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation

typealias evalFunc = (String)->LSLogSink

let generateObject: evalFunc = {classname -> LSLogSink in
    let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
    let className = appName+"."+classname
    return (NSClassFromString(className) as! NSObject.Type).init() as! LSLogSink
}

class LSConfiguration{
    
    //Move to configuration and try catch
    func prepareLogSink() -> LSLogSink {
        var logSink: LSLogSink!

        if let logType = getLogTypeFromConfiguration() {
            logSink = logSinkforType(type: logType)
        }
        
        return logSink
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
    
    private var logOption: Dictionary<String, LSLogType> = [
        "📕" : .Console{generateObject($0)},
        "📗" : .Database{generateObject($0)},
        "📒" : .File{generateObject($0)}
    ]
    
    private func logSinkforType(type: String)->LSLogSink {
        var logSink: LSLogSink!
        if let logType =  logOption[type]{
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
