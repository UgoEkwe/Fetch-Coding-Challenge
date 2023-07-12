//
//  DessertDetailViewModel.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import Foundation

/* The `Difficulty` enum represents the difficlty level of a recipe.
It has three cases: `easy`, `medium`, and `hard`. Each case is associated with an int value and a description.
It has a static function `calculateDifficulty()` that calculates the difficulty level of the recipe based on the number of ingredients.*/

enum Difficulty: Int {
    case easy = 1
    case medium = 2
    case hard = 3
    
    var description: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
    
    // Calculate the difficulty based on the number of ingredients.
    static func calculateDifficulty(basedOnIngredientCount ingredientCount: Int) -> Difficulty {
        switch ingredientCount {
        case 0...5:
            return .easy
        case 6...10:
            return .medium
        default:
            return .hard
        }
    }
}

/* Fetches a `DessertDetail` object which contains detailed information about a dessert.
The `detailsFetched` property alerts views that the dessert details have been successfuly fetched and are ready for use.
The `fetchDessertDetail() method makes a network request to fetch the details of a dessert.
Has a guard that check if an ingredient is a duplicate before inserting it into the list.
The result of the request is handled in a closure, where it updates the dessert details in case of success,
or calls `onNetworkError` in case of errors.
If successful, it calculates the difficulty of the recipe and alerts views that the dessert details have been fetched.*/

class DessertDetailViewModel: ObservableObject {
    private var networkService = NetworkService()
    @Published var dessertDetail: DessertDetail?
    @Published var detailsFetched: Bool = false
    var onNetworkError: ((NetworkError) -> Void)?
    
    @Published var difficulty: Difficulty = .easy
    
    func fetchDessertDetail(for mealId: String) {
        networkService.fetchDessertDetail(mealId: mealId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedDessertDetails):
                    // Added a guard here to check for duplicate ingredients before insertion
                    if var fetchedDessert = fetchedDessertDetails.first {
                        var seen = Set<String>()
                        fetchedDessert.ingredients = fetchedDessert.ingredients.filter {
                            guard !seen.contains($0.name) else { return false }
                            seen.insert($0.name)
                            return true
                        }
                        self?.dessertDetail = fetchedDessert
                    }
                    
                    self?.detailsFetched = true
                    
                    // Calculate the difficulty based on the number of ingredients. This is just filler as the logic is not very complex.
                    if let ingredientCount = self?.dessertDetail?.ingredients.count {
                        self?.difficulty = Difficulty.calculateDifficulty(basedOnIngredientCount: ingredientCount)
                    }
                case .failure(let error):
                    self?.onNetworkError?(error)
                }
            }
        }
    }
}
