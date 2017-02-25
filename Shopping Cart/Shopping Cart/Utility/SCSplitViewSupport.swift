//
//  SCSplitViewSupport.swift
//  Shopping Cart
//
//  Created by Bhabani on 25/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

extension UISplitViewController: UISplitViewControllerDelegate {
    
    struct ios7Support {
        static var modeButtonItem: UIBarButtonItem?
    }
    
    var backBarButtonItem: UIBarButtonItem? {
        get {
            if responds(to: #selector(getter: UISplitViewController.displayModeButtonItem)) == true {
                let button: UIBarButtonItem = displayModeButtonItem
                return button
            } else {
                return ios7Support.modeButtonItem
            }
        }
        set {
            ios7Support.modeButtonItem = newValue
        }
    }
    
    func displayModeButtonItem(_: Bool = true)->UIBarButtonItem? {
        return backBarButtonItem
    }
    
    public func splitViewController(_ svc: UISplitViewController, willShow aViewController: UIViewController, invalidating barButtonItem: UIBarButtonItem) {
        if (!svc.responds(to: #selector(getter: UISplitViewController.displayModeButtonItem))) {
            if let detailView = svc.viewControllers.last as? UINavigationController {
                svc.backBarButtonItem = nil
                detailView.topViewController?.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    // MARK: - Show detail if it is selected from list
    public func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        if let controller = secondaryViewController.contentViewController as? SCDetailViewController {
            return !controller.detailContentAvailable
        }
        
        return true
    }
}
