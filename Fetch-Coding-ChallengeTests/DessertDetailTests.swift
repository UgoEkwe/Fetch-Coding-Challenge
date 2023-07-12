//
//  DessertDetailTests.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import XCTest
@testable import Fetch_Coding_Challenge

/* The `DessertDetailTests` suite test the creation and properties of DessertDetail model.
It verifies if a DessertDetail object can be correctly initialized with id, name, region, instructions, and image URL, ingredients.
It also tests for any possible duplicqtion of ingredients in a dessert.
It also ensures the image URL for the dessert detail is correctly formed.*/

final class DessertDetailTests: XCTestCase {

    func testDessertDetailInitialization() {
        let ingredient = Ingredient(name: "Sugar", measure: "1 cup")
        let dessertDetail = DessertDetail(id: "1", name: "Test Dessert", region: "Test Region", instructions: "Test Instructions", image: URL(string: "https://test.com")!, ingredients: [ingredient])
        
        XCTAssertNotNil(dessertDetail, "DessertDetail init failed")
        XCTAssertEqual(dessertDetail.id, "1", "DessertDetail ID init failed")
        XCTAssertEqual(dessertDetail.name, "Test Dessert", "DessertDetail name init failed")
        XCTAssertEqual(dessertDetail.region, "Test Region", "DessertDetail region init failed")
        XCTAssertEqual(dessertDetail.instructions, "Test Instructions", "DessertDetail instructions init failed")
        XCTAssertEqual(dessertDetail.image, URL(string: "https://test.com")!, "DessertDetail image URL init failed")
        XCTAssertEqual(dessertDetail.ingredients.first?.name, "Sugar", "DessertDetail ingredients init failed")
    }

    func testIngredientDuplicationCheck() {
        let ingredient = Ingredient(name: "Sugar", measure: "1 cup")
        let dessertDetail = DessertDetail(id: "1", name: "Test Dessert", region: "Test Region", instructions: "Test Instructions", image: URL(string: "https://test.com")!, ingredients: [ingredient, ingredient])
        
        let hasDuplicates = dessertDetail.ingredients.count != Set(dessertDetail.ingredients).count
        XCTAssertTrue(hasDuplicates, "Ingredient duplication check failed")
    }

    func testURLFormation() {
        let ingredient = Ingredient(name: "Sugar", measure: "1 cup")
        let dessertDetail = DessertDetail(id: "1", name: "Test Dessert", region: "Test Region", instructions: "Test Instructions", image: URL(string: "https://test.com")!, ingredients: [ingredient])
        XCTAssertEqual(dessertDetail.image, URL(string: "https://test.com")!, "URL Formation failed for DessertDetail")
    }
}

