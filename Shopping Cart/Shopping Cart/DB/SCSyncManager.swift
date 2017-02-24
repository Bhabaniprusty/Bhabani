//
//  SCSyncManager.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation


typealias evalFunc = ()->TimeInterval

class SCSyncManager{
    
    struct Static {
        static let syncIntervalKey = "syncIntervalKey"
    }
    private var syncTimer: Timer?
    static let sharedInstance = SCSyncManager()
    
    private init() {
    }


    enum SCSyncAction {
        case Start(evalFunc)
        case Stop
    }
    
    
    //This can be fetch from anywhere- bundle file, network etc
    private var operation: Dictionary<String, SCSyncAction> = [
        "👍" : SCSyncAction.Start{60},
        "👊" : SCSyncAction.Start{3600},
        "👎" : SCSyncAction.Stop
    ]

    func perFormSyncCommand(action: String) {
        if let evaluation =  operation[action]{
            switch evaluation {
            case .Start(let funnction):
                startSync(timeInterval: funnction())
            case .Stop:
                stopSync()
            }
        }
        
        UserDefaults.standard.set(action, forKey: Static.syncIntervalKey)
    }
    
    func startSync() {
        let syncAction = UserDefaults.standard.value(forKey: Static.syncIntervalKey) as? String ?? "👍"
        perFormSyncCommand(action: syncAction)
    }

    private func startSync(timeInterval: TimeInterval) {
        syncTimer?.invalidate()
        syncTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.syncStorage), userInfo: nil, repeats: true);
        syncTimer?.fire()
        
    }
    
    func stopSync() {
        syncTimer?.invalidate()
    }
    
    @objc private func syncStorage() {
        SCUtility.fetchUpdatedProductCatalogs()
    }
    
    deinit {
        syncTimer?.invalidate()
    }

}
