//
//  KeyManager.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import Foundation

/* Fetch the API Key that the project will leverage */

class KeyManager {
    static let shared = KeyManager()
    
    private var apiKey: String? = ""

    private init() {
        self.apiKey = getAPIKey()
    }
    
    func getAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let keys = NSDictionary(contentsOfFile: path),
              let apiKey = keys["TheMealDB"] as? String else {
            print("Error: Couldn't load API key")
            return nil
        }
        return apiKey
    }
}
