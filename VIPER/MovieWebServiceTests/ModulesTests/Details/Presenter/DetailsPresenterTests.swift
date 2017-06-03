//
//  DetailsPresenterTests.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//


import XCTest
import UIKit

@testable
import MovieWebService

class DetailsPresenterTests: XCTestCase {

    var presenter: DetailsPresenter!
    var mockRouter: MockRouter!
    var mockInteractor: MockInteractor!
	
    override func setUp() {
        super.setUp()
		
        mockRouter = MockRouter()
        mockInteractor = MockInteractor()

        presenter = DetailsPresenter()
        presenter.router = mockRouter
        presenter.interactor = mockInteractor
        presenter.setupView(UIView())

    }
    // The code can move to different class (Data source) and test
    func testIfMathodsInvoked() {
        //given
        let actorCount = 5
        mockInteractor.actorCount = actorCount

        
        XCTAssertEqual(1,  presenter.tableView(UITableView(), numberOfRowsInSection: 0))
        XCTAssertEqual(1,  presenter.tableView(UITableView(), numberOfRowsInSection: 1))
        
        // when
        let tappableLabel = TappableLabel(frame: CGRect.zero)
        tappableLabel.tag = 1
        presenter.didReceiveTouch(tappableLabel)
        
        XCTAssertEqual(actorCount,  presenter.tableView(UITableView(), numberOfRowsInSection: 1))
    }
    
    override func tearDown() {
        mockRouter = nil
        mockInteractor = nil

        super.tearDown()
    }

    // MARK: - Mock

    class MockInteractor: DetailsInteractorInput {
        var castInfoDidCall = false
        var actorCount: Int!
        
        var directorName: String {
            return "Ben Affleck1"
        }
        
        var castCount: Int {
            return actorCount
        }
        
        func castInfo(withIndex index: Int) -> (name: String, screenName: String){
            castInfoDidCall = true
            return (name: "Ben Affleck", screenName: "Jack Donnell")
        }
    }

    class MockRouter: DetailsRouterInput {

    }

}

