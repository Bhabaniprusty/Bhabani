//
//  DetailsModuleBuilder.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

import UIKit

@objc final class DetailsModuleBuilder: NSObject {

    func build(with data: Film) -> UIViewController {

        let viewController = DetailsViewController()

        let interactor = DetailsInteractor(with: data)

        let router = DetailsRouter()
        router.view = viewController

        let presenter = DetailsPresenter()
        presenter.interactor = interactor
        presenter.router = router
        
        viewController.presenter = presenter

        return viewController
    }
}
