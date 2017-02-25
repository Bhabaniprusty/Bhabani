//
//  SCSplitViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class SCSplitViewController: UISplitViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI(traitCollection: self.traitCollection)
    }
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        updateUI(traitCollection: newCollection)
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    private func updateUI(traitCollection: UITraitCollection){
        let rightBarButtonItem = (viewControllers.first as? UINavigationController)?.topViewController?.navigationItem.rightBarButtonItem
        if (traitCollection.horizontalSizeClass == .regular){
            rightBarButtonItem?.tintColor = UIColor.clear
            rightBarButtonItem?.isEnabled = false
        }else{
            rightBarButtonItem?.tintColor = view.tintColor
            rightBarButtonItem?.isEnabled = true
        }
    }
}
