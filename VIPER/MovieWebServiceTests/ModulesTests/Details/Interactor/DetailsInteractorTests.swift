//
//  DetailsInteractorTests.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

import XCTest

@testable
import MovieWebService
import OCMock

class DetailsInteractorTests: XCTestCase {

    var interactor: DetailsInteractor!
    var film: Film!
	
    override func setUp() {
        super.setUp()
        
        let data: [String: Any] = ["filmRating" : 3,
                                   "languages" : ["English", "Thai"],
                                   "nominated" : true,
                                   "releaseDate" : 1350000000,
                                   "casts" : [["dateOfBirth" : -436147200,
                                               "nominated" : true,
                                               "name" : "Bryan Cranston",
                                               "screenName" : "Jack Donnell",
                                               "biography" : "Bryan Lee Cranston is an American actor, voice actor, writer and director."
                                    ]],
                                   "name" : "Argo",
                                   "rating" : 7.8,
                                   "director" : ["dateOfBirth" : 82684800,
                                                 "nominated" :  true,
                                                 "name" : "Ben Affleck",
                                                 "biography" : "Benjamin Geza Affleck was born on August 15, 1972 in Berkeley, California, USA but raised in Cambridge, Massachusetts, USA."]]
        
        film = Film(data: data)
        interactor = DetailsInteractor(with: film)
    }

    func testDirectorName() {
        XCTAssertEqual("Ben Affleck", interactor.directorName)
    }

    func testCastCount() {
        XCTAssertEqual(1, interactor.castCount)
    }

    func testCastInfo() {
        let testCastInfo = (name: "Bryan Cranston", screenName: "Jack Donnell")
        let outputCastInfo = interactor.castInfo(withIndex: 0)
        XCTAssertEqual(testCastInfo.name, outputCastInfo.name)
        XCTAssertEqual(testCastInfo.screenName, outputCastInfo.screenName)
    }
    
    override func tearDown() {
        interactor = nil
        film = nil
        super.tearDown()
    }
}
 
