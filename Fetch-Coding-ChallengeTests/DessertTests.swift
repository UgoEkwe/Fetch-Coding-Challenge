//
//  DessertTests.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import XCTest
@testable import Fetch_Coding_Challenge

/* The `DessertTests` suited tests the creation and properties of Dessert model.
It verifies that Dessert object can be created with an id, name, and image URL.
The suite also tests the correct formation of the URL property for image.*/

final class DessertTests: XCTestCase {

    func testDessertInitialization() {
        let dessert = Dessert(id: "1", name: "Test Dessert", image: URL(string: "https://test.com")!)
        
        XCTAssertNotNil(dessert, "Dessert init failed")
        XCTAssertEqual(dessert.id, "1", "Dessert ID init failed")
        XCTAssertEqual(dessert.name, "Test Dessert", "Dessert name init failed")
        XCTAssertEqual(dessert.image, URL(string: "https://test.com")!, "Dessert image URL init failed")
    }

    func testURLFormation() {
        let dessert = Dessert(id: "1", name: "Test Dessert", image: URL(string: "https://test.com")!)
        XCTAssertEqual(dessert.image, URL(string: "https://test.com")!, "URL Formation failed for Dessert")
    }
}

