//
//  WheatherMapUITests.swift
//  WheatherMapUITests
//
//  Created by Somsubhra Dasgupta on 09/04/21.
//  Copyright © 2021 Somsubhra. All rights reserved.
//

import XCTest

class WheatherMapUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        
        let app = XCUIApplication()
        app.launch()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Puri"]/*[[".cells.staticTexts[\"Puri\"]",".staticTexts[\"Puri\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let collectionViewsQuery = app.collectionViews
        let element = collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element
        element.swipeLeft()
        
        let element2 = element.children(matching: .other).element
        element2.swipeRight()
        
        let locationListButton = app.navigationBars["City screen"].buttons["Location List"]
        locationListButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Kolkata"]/*[[".cells.staticTexts[\"Kolkata\"]",".staticTexts[\"Kolkata\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.swipeLeft()
        element2.swipeRight()
        locationListButton.tap()
        
        let locationListNavigationBar = app.navigationBars["Location List"]
        locationListNavigationBar.buttons["plus"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add Location"]/*[[".buttons[\"Add Location\"].staticTexts[\"Add Location\"]",".staticTexts[\"Add Location\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Add location title"].scrollViews.otherElements.buttons["Add"].tap()
        locationListNavigationBar.buttons["Help"].tap()
        app.navigationBars["Help"].buttons["Location List"].tap()
        locationListNavigationBar.buttons["trash"].tap()
        app.alerts["Alert"].scrollViews.otherElements.buttons["Delete"].tap()
        
        
        
        // UI tests must launch the application that they test.
        
        
        
        
        
        
                // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
