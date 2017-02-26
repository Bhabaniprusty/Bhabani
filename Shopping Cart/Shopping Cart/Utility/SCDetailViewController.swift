//
//  SCDetailViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 24/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class SCDetailViewController: UIViewController, SCDetail {
    var catalog: ProductCatalog?
    var detailContentAvailable = false
}


protocol SCDetail{
    var detailContentAvailable: Bool {get}
    var catalog: ProductCatalog? {get set}
}
