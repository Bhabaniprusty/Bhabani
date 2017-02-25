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
        
        
        
        
        self.init(title: NSLocalizedString("Auto Sync",
                                           comment: "Auto Sync functionality title"),
                  message: NSLocalizedString("Application will check avaibility of cart Items",
                                             comment: "Auto Sync functionality description"),
                  preferredStyle: .actionSheet)
        
        addAction(UIAlertAction(title: NSLocalizedString("Frequently",
                                                         comment: "Auto Sync will work frequently"),
                                style: .default) { (action) in
            SCSyncManager.sharedInstance.perFormSyncCommand(action: "👍")
        })
        
        addAction(UIAlertAction(title: NSLocalizedString("Hourly",
                                                         comment: "Auto Sync will work Hourly"),
                                style: .default) { (action) in
            SCSyncManager.sharedInstance.perFormSyncCommand(action: "👊")
        })
        
        addAction(UIAlertAction(title: NSLocalizedString("Do not Sync",
                                                         comment: "Auto Sync will be stooped"),
                                style: .destructive) { (action) in
            SCSyncManager.sharedInstance.perFormSyncCommand(action: "👎")
        })
        
        addAction(UIAlertAction(title: NSLocalizedString("Cancel",
                                                         comment: "Cancel the wizard"),
                                style: .cancel) { (action) in
            
        })
    }
}
