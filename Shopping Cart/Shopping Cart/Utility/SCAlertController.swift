//
//  SCAlertController.swift
//  Shopping Cart
//
//  Created by Bhabani on 24/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(message: String?) {
        
        
        self.init(title: "Auto Sync", message: "Application will check avaibility of cart Items", preferredStyle: .actionSheet)
        
        self.addAction(UIAlertAction(title: "Frequently", style: .default, handler: { (action) in
            SCSyncManager.sharedInstance.perFormSyncCommand(action: "👍")
        }))
        
        self.addAction(UIAlertAction(title: "Hourly", style: .default, handler: { (action) in
            SCSyncManager.sharedInstance.perFormSyncCommand(action: "👊")
        }))
        
        self.addAction(UIAlertAction(title: "Do not Sync", style: .destructive, handler: { (action) in
            SCSyncManager.sharedInstance.perFormSyncCommand(action: "👎")
        }))
        
        self.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
    }
}
