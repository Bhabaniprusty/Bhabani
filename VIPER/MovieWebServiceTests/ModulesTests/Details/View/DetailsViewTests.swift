//
//  DetailsViewTests.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

import XCTest

@testable
import MovieWebService


class DetailsViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testIfViewIsReady() {
        //given
        let mockPresenter = MockPresenter()
        let viewController = DetailsViewController()
        viewController.presenter = mockPresenter


        //when 
        viewController.loadView()

        //then
        XCTAssertTrue(mockPresenter.viewSetupDidCall)
    }

    // MARK: - Mock

    class MockPresenter: DetailsPresenterInput {
        var viewSetupDidCall = false
        var updateUIDidCall = false
        
        func setupView(_ view: UIView){
            viewSetupDidCall = true
        }
    }
}
 
