//
//  DetailsModuleBuilderTests.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

import XCTest

@testable
import MovieWebService


class DetailsModuleBuilderTests: XCTestCase {

    func testBuildViewController() {

        // given
        let builder = DetailsModuleBuilder()

        // when
        let viewController = builder.build(with: Film()) as! DetailsViewController

        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(viewController.presenter is DetailsPresenter)

        let presenter: DetailsPresenter = viewController.presenter as! DetailsPresenter
        XCTAssertNotNil(presenter.interactor)
        XCTAssertTrue(presenter.interactor is DetailsInteractor)
        XCTAssertNotNil(presenter.router)
        XCTAssertTrue(presenter.router is DetailsRouter)


        let router: DetailsRouter = presenter.router as! DetailsRouter
        XCTAssertNotNil(router.view)
    }

}
