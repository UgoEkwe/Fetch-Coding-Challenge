//
//  NetworkService.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import Foundation
import UIKit

/* 'decodingError`: This error occurs when there's an issue with decoding the data received from the server.
`httpError`: This error means there was an issue with the network request itself.
`noData`: This error is for the case when no data was received.*/
enum NetworkError: Error {
    case decodingError
    case httpError
    case noData
}

/* `fetchDesserts()`: This method fetches a list of `Dessert` objects from TheMealDB API. If successful, the fetched data is decoded into an array of `Dessert` objects.
If an error occurs during this process, it is wrapped in a `NetworkError` and passed to the `completion` closure.

`fetchDessertDetail()`: This method fetches detailed information about a single dessert identified by `mealId`.
 Has a guard to ensure the data received from the api is not invalid or empty.
 If successful, the fetched data is transformed into a `DessertDetail` object, which is then passed to the `completion` closure.
 If an error occurs at any point during this process, it is wrapped in a `NetworkError` and passed to the `completion` closure.*/

class NetworkService {
    let apiKey = KeyManager.shared.getAPIKey()
    let baseURL = "https://themealdb.com/api/json/v1/"
    
    func fetchDesserts(completion: @escaping (Result<[Dessert], NetworkError>) -> Void) {
        let url = URL(string: baseURL + "\(apiKey ?? "")/filter.php?c=Dessert")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.httpError))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let dessertData = try decoder.decode(DessertResponse.self, from: data)
                    completion(.success(dessertData.meals))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    func fetchDessertDetail(mealId: String, completion: @escaping (Result<[DessertDetail], NetworkError>) -> Void) {
        let url = URL(string: baseURL + "\(apiKey ?? "")/lookup.php?i=\(mealId)")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.httpError))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let mealData = jsonObject as? [String: [MealData]],
                      let meal = mealData["meals"]?.first else {
                    completion(.failure(.decodingError))
                    return
                }
                
                var ingredients: [Ingredient] = []
                for count in 1...20 {
                    if let ingredientName = meal["strIngredient\(count)"] as? String,
                       let ingredientMeasure = meal["strMeasure\(count)"] as? String,
                       !ingredientName.isEmpty, !ingredientMeasure.isEmpty {
                        ingredients.append(Ingredient(name: ingredientName, measure: ingredientMeasure))
                    }
                }
                
                let id = meal["idMeal"] as? String ?? ""
                let name = meal["strMeal"] as? String
                let region = meal["strArea"] as? String ?? ""
                let instructions = meal["strInstructions"] as? String
                let imageURL = URL(string: meal["strMealThumb"] as? String ?? "") ?? URL(fileURLWithPath: "")
                
                // Added guard to ensure the data received from the api is not invalid or empty
                guard let name = name, !name.isEmpty,
                      let instructions = instructions, !instructions.isEmpty else {
                    completion(.failure(.decodingError))
                    return
                }
                
                let dessertDetail = DessertDetail(
                    id: id,
                    name: name,
                    region: region,
                    instructions: instructions,
                    image: imageURL,
                    ingredients: ingredients
                )
                completion(.success([dessertDetail]))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

/* `MealData` is a typealias for a dictionary that maps a string to any type (`[String: Any]`).
This type is used to help decode JSON data received from the network into a more manageable form for further processing.*/
typealias MealData = [String: Any]

