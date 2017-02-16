//
//  MyntraGameTests.swift
//  MyntraGameTests
//
//  Created by Bhabani on 09/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import XCTest
@testable import MyntraGame

class MyntraGameTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Utility class testing
    func testRandomSequence() {
        let max = 100
        let sequenceProvider = MGRandomSequenceNumberProvider(max: max)
        var set = Set<Int>()
        
        var x = sequenceProvider.nextRandomSequence()
        while (x != nil){
            set.insert(x!)
            x = sequenceProvider.nextRandomSequence()

        }
        
        XCTAssert(set.count == max, "Unique method has problem")
    }
    
    
    
    //API testing
    func testFetchAllCard() {
        
        let fetchCardExpectation = expectation(description: "fetc all contact")
        let task = MGNetworkManager.sharedInstance.fetchCards(completion: { (cards) in
            XCTAssertNotNil(cards, "cards should not be nil")
            fetchCardExpectation.fulfill()
        })
        
        waitForExpectations(timeout: (task?.originalRequest!.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task?.cancel()
        }
    }
    /*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
 */
    
}
