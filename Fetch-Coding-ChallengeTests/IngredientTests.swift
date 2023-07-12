//
//  IngredientTests.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import XCTest
@testable import Fetch_Coding_Challenge

/* The `IngredientTests` suite test the creation and properties of the Ingredient model.
It verifies that an Ingredient object can be correctly created with name and measure properties.
It also tests the formation of the imageURL property, which should correctly encode the ingredient's name in the URL.*/

final class IngredientTests: XCTestCase {

    func testIngredientInitialization() {
        let ingredient = Ingredient(name: "Sugar", measure: "1 cup")
        
        XCTAssertNotNil(ingredient, "Ingredient init failed")
        XCTAssertEqual(ingredient.name, "Sugar", "Ingredient name init failed")
        XCTAssertEqual(ingredient.measure, "1 cup", "Ingredient measure init failed")
        XCTAssertEqual(ingredient.imageURL, URL(string: "https://www.themealdb.com/images/ingredients/Sugar-Small.png")!, "Ingredient imageURL init failed")
    }

    func testURLFormation() {
        let ingredient = Ingredient(name: "Sugar", measure: "1 cup")
        XCTAssertEqual(ingredient.imageURL, URL(string: "https://www.themealdb.com/images/ingredients/Sugar-Small.png")!, "URL Formation failed for Ingredient")
    }
}
