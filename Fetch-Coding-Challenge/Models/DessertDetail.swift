//
//  DessertDetail.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import Foundation

struct DessertDetailResponse: Decodable {
    let meals: [DessertDetail]
}

/* The `DessertDetail` struct represents structure designed to
   retreive information about a meal from the lookup endpoint.
   This includes the id, name, category, region, instructions,
   url to an image, and a list of ingredients.
*/

struct DessertDetail: Identifiable, Decodable {
    var id: String
    var name: String
    var region: String
    var instructions: String
    var image: URL
    var ingredients: [Ingredient]
}

/* The `Ingredient` struct represents structure designed to
   retreive information about an ingredient from the ingredients endpoint.
   This includes the name, measure, and a base url for a small thumbnail.
   The url encodes spaces an special characters.
*/

struct Ingredient: Decodable, Hashable {
    let name: String
    let measure: String
    var imageURL: URL? {
        URL(string: "https://www.themealdb.com/images/ingredients/\(name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")-Small.png")
    }
}
