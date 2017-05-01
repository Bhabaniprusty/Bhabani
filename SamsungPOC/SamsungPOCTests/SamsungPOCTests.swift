//
//  SamsungPOCTests.swift
//  SamsungPOCTests
//
//  Created by Bhabani on 24/04/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import XCTest
@testable import SamsungPOC

class SamsungPOCTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testFetcgImageUrls() {
        let fetchImgExpectation = expectation(description: "fetchImageUrl")
        
        let task = SPNetworkEngine.loadItems { (items) in
            //print(items)
            XCTAssert(items != nil)
            fetchImgExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: (task.request?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }

    }

}
