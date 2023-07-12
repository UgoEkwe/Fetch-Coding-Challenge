//
//  UtilityTests.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import XCTest
@testable import Fetch_Coding_Challenge

/* The `UtilityTests` suite tests the functionality of utility functions within the application.
Here we test the `calculateDifficulty` function which determines the difficulty level based on ingredient count.*/

final class UtilityTests: XCTestCase {

    func testDifficultyCalculation() {
        let easy = Difficulty.calculateDifficulty(basedOnIngredientCount: 3)
        let medium = Difficulty.calculateDifficulty(basedOnIngredientCount: 7)
        let hard = Difficulty.calculateDifficulty(basedOnIngredientCount: 12)
        
        XCTAssertEqual(easy, Difficulty.easy, "Difficulty calculation failed for easy")
        XCTAssertEqual(medium, Difficulty.medium, "Difficulty calculation failed for medium")
        XCTAssertEqual(hard, Difficulty.hard, "Difficulty calculation failed for hard")
    }
}
