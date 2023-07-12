//
//  DessertListViewUITest.swift
//  Fetch Coding ChallengeUITests
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import XCTest

/* The `DessertListViewUITest` suite tests the functionalities of the DessertListView,
such as the presence and functionality of the search bar, the ability to interact with dessert cells, and navigation. */

class DessertListViewUITest: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testPresenceOfSearchBar() {
        let searchBar = app.textFields["Search any recipes"]
        XCTAssert(searchBar.waitForExistence(timeout: 5))
    }

    func testSearchFunctionality() {
        let searchBar = app.textFields["Search any recipes"]
        searchBar.tap()
        searchBar.typeText("Apple Pie\n")
    }

    func testDessertCellExistenceAndNavigation() {
        let firstDessertCell = app.staticTexts["DessertCell-53049"] // The mealID of Apam Balek the first dessert in the list
        XCTAssert(firstDessertCell.waitForExistence(timeout: 10))

        firstDessertCell.tap()

        let dessertDetailTitle = app.staticTexts["DetailTitle"]
        XCTAssert(dessertDetailTitle.waitForExistence(timeout: 5))
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
}
