//
//  DessertListViewModel.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import Foundation

/* Fetches an array of `Dessert` objects using NetworkService.
The `fetchDesserts()` method makes a network request to fetch all desserts.
The results of the request is handled in a closure, where it updates desserts array in case of success,
or calls `onNetworkError` in case of errors.*/

class DessertListViewModel: ObservableObject {
    private var networkService = NetworkService()
    
    @Published var desserts: [Dessert] = []
    
    var onNetworkError: ((NetworkError) -> Void)?
    
    func fetchDesserts() {
        networkService.fetchDesserts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedDesserts):
                    self?.desserts = fetchedDesserts
                case .failure(let error):
                    self?.onNetworkError?(error)
                }
            }
        }
    }
}
