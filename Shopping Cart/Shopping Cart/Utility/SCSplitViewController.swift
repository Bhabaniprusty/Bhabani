//
//  SCSplitViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class SCSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.traitCollection.userInterfaceIdiom == .pad){
            (viewControllers.first as? UINavigationController)?.topViewController?.navigationItem.rightBarButtonItem = nil
            self.preferredDisplayMode = .allVisible
        }

        super.viewWillAppear(animated)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator){
        let rightBarButtonItem = (viewControllers.first as? UINavigationController)?.topViewController?.navigationItem.rightBarButtonItem
        if (newCollection.horizontalSizeClass == .regular){
            rightBarButtonItem?.tintColor = UIColor.clear
            rightBarButtonItem?.isEnabled = false
        }else{
            rightBarButtonItem?.tintColor = self.view.tintColor

            rightBarButtonItem?.isEnabled = true
        }
        super.willTransition(to: newCollection, with: coordinator)
    }

    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool{
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? SCDetailViewController else { return false }
        if !topAsDetailController.detailContentAvailable {
            return true
        }
        
        return false
    }
}
