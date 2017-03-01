//
//  Shopping_CartUITests.swift
//  Shopping CartUITests
//
//  Created by Bhabani on 22/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import XCTest

class Shopping_CartUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddToCart() {
        
        let app = XCUIApplication()
        app.navigationBars["Shopping_Cart.SCCartView"].buttons["Add"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["name is mobile1"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["addToCart"].tap()
        
        let nameIsMobile1NavigationBar = app.navigationBars["name is mobile1"]
        nameIsMobile1NavigationBar.buttons["Cancel"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"name is mobile1").children(matching: .staticText).matching(identifier: "name is mobile1").element(boundBy: 1).tap()
        elementsQuery.buttons["removeFromCart"].tap()
        nameIsMobile1NavigationBar.children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
