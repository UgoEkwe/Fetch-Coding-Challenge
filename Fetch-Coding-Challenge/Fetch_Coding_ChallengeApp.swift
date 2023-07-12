//
//  Fetch_Coding_ChallengeApp.swift
//  Fetch-Coding-Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import SwiftUI

/* This App Fetches desserts from an API and lists them alphabvetically.
When a desert is selected from the list, a detail view is shown with instructions and ingredients.*/

@main
struct Fetch_Coding_ChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            DessertListView()
        }
    }
}
