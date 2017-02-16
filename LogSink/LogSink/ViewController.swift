//
//  ViewController.swift
//  LogSink
//
//  Created by Bhabani on 16/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        LSLogUtill.log(eventType: "iOS",
                       eventTitle: "Button Clicked",
                       eventDetail: ["ButtonType" : "LoginButton",
                                     "HardPress" : "YES"])
    }


}

