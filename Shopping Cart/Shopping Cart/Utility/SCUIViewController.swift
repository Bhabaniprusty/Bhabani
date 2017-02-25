//
//  SCUIViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 25/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

extension UIViewController{
    var contentViewController: UIViewController?{
        if let navCon = self as? UINavigationController {
            return navCon.topViewController
        }else{
            return self
        }
    }
}
