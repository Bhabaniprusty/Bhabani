//
//  DetailsViewController.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {

    var presenter: DetailsPresenterInput!

    override func loadView() {
        super.loadView()
        presenter.setupView(view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
