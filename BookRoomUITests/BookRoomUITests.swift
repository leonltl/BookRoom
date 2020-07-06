//
//  BookRoomUITests.swift
//  BookRoomUITests
//
//  Created by Leonard Lim on 1/7/20.
//  Copyright © 2020 Leonard Lim. All rights reserved.
//

import XCTest

class BookRoomUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRoomList() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 0).tap()
        
        
        // Test for the date picker
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        element.children(matching: .textField).element(boundBy: 1).tap()
        
        // Test for the time picker
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "7")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "10")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        doneButton.tap()
       
        // Test for the table view to display the result
        var tblRoomAvailability = app.tables.matching(identifier: "tblRoomAvailability")
        XCTAssertEqual(tblRoomAvailability.children(matching: .cell).count, 15)
        
        // Test if first cell of the table showing correctly
        var cell = tblRoomAvailability.cells.element(boundBy: 0)
        var labelName = cell.staticTexts["Name"]
        XCTAssertEqual(labelName.label, "Kopi-O")
        var labelAvailability = cell.staticTexts["Availability"]
        XCTAssertEqual(labelAvailability.label, "Not Available")
        
        // Test sort button to show the popup, choose Capacity sorting and can select apply button
        app.buttons["Sort"].tap()
        element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element.tap()
        XCTAssert(app.buttons["Apply"].exists)
        app.buttons["Apply"].tap()
        
        // Test to ensure that the table sort the data correctly in according to Capacity in descending by checking the first cell
        tblRoomAvailability = app.tables.matching(identifier: "tblRoomAvailability")
        cell = tblRoomAvailability.cells.element(boundBy: 0)
        labelName = cell.staticTexts["Name"]
        XCTAssertEqual(labelName.label, "Laksa")
        labelAvailability = cell.staticTexts["Availability"]
        XCTAssertEqual(labelAvailability.label, "Available")
        
        // Test sort button to show the popup, choose Availablity sorting and can select apply button
        app.buttons["Sort"].tap()
        element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .button).element.tap()
        app.buttons["Apply"].tap()
        
        // Test to ensure that the table sort the data correctly in according to Availability in descending by checking the first cell
        tblRoomAvailability = app.tables.matching(identifier: "tblRoomAvailability")
        cell = tblRoomAvailability.cells.element(boundBy: 0)
        labelName = cell.staticTexts["Name"]
        XCTAssertEqual(labelName.label, "Laksa")
        labelAvailability = cell.staticTexts["Availability"]
        XCTAssertEqual(labelAvailability.label, "Available")
        
        // Test the reset button
        app.buttons["Sort"].tap()
        XCTAssert(app.buttons["Reset"].exists)
        app.buttons["Reset"].tap()
        app.buttons["Apply"].tap()
        
        // Test the reset logic to ensure that it is sorted by Capcity in acsending
        tblRoomAvailability = app.tables.matching(identifier: "tblRoomAvailability")
        cell = tblRoomAvailability.cells.element(boundBy: 0)
        labelName = cell.staticTexts["Name"]
        XCTAssertEqual(labelName.label, "Kopi-O")
        labelAvailability = cell.staticTexts["Availability"]
        XCTAssertEqual(labelAvailability.label, "Not Available")
        
        // Test for camera view showing up
        let cameraButton = XCUIApplication().navigationBars["Book a Room"].buttons["camera"]
        cameraButton.tap()
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate,
                    evaluatedWith: app.otherElements["QrCamera"], handler: nil)
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
   
    /*
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    */
}
