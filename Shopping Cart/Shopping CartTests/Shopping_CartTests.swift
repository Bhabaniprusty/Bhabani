//
//  Shopping_CartTests.swift
//  Shopping CartTests
//
//  Created by Bhabani on 22/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import XCTest
@testable import Shopping_Cart

class Shopping_CartTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchCatalog() {
        let cretaeContactExpectation = expectation(description: "fetch catalog")
        
        
        let task = SCNetworkMager.sharedInstancer.fetchProductCatalogs(updatedAfterDate: nil,
                                                            pageIndex: 0,
                                                            pageSize: 10) { (jsonArr, error) in
                                                                
                                                                XCTAssertNil(error, "error should be nil")
                                                                cretaeContactExpectation.fulfill()
        }

        waitForExpectations(timeout: (task?.originalRequest!.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task?.cancel()
        }
    }

    func testFetchStorage() {
        let cretaeContactExpectation = expectation(description: "fetch storage")
        
        
        let task = SCNetworkMager.sharedInstancer.fetchProductStorages(updatedAfterDate: nil,
                                                                       pageIndex: 0,
                                                                       pageSize: 10) { (jsonArr, error) in
                                                                        
                                                                        XCTAssertNil(error, "error should be nil")
                                                                        cretaeContactExpectation.fulfill()
        }
        
        waitForExpectations(timeout: (task?.originalRequest!.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task?.cancel()
        }
    }

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
    
}
