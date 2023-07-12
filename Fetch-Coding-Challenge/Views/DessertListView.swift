//
//  DessertListView.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//

import SwiftUI

/* The `DessertListView` struct presents a list of desserts horizontally.
When a user clicks on a dessert it presents a detail view of that dessert.
The observed object `dessertViewModel` is used to retrieve the list of desserts from the api.
The list of desserts is filtered based on the State variable `searchText`.
The list of desserts is sorted alphabetically.
Ussr can search for desserts in list.
The initial list of desserts is fetched when the view appears.
The design for this view was inspired by https://dribbble.com/shots/20792040-Cookpedia-Food-Recipe-Mobile-App*/

struct DessertListView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var dessertViewModel = DessertListViewModel()
    @State private var searchText = ""
    
    // List of deserts is filtered by searchText, if searchText is empty then return full list in alphabetical order,
    // if not empty then search for the key words in the list and return list sorted alphabetically.
    var filteredDesserts: [Dessert] {
        var desserts: [Dessert]
        if searchText.isEmpty {
            desserts = dessertViewModel.desserts
        } else {
            desserts = dessertViewModel.desserts.filter { dessert in
                dessert.name.lowercased().contains(searchText.lowercased())
            }
        }
        return desserts.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack{
                    HStack {
                        VStack(alignment: .leading){
                            Text("Hello,")
                                .font(.title3)
                                .foregroundColor(Color(.systemGray2))
                            Text("What would you like")
                                .font(.title.bold())
                            Text("to cook today?")
                                .font(.title.bold())
                        }
                        .padding(.leading)
                        Spacer()
                    }
                    .padding(.top, 35)
                    HStack {
                        TextField("Search any recipes", text: $searchText)
                            .accessibilityIdentifier("Search any recipes")
                            .padding(10)
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                    .background(Color(.systemGray4))
                    .cornerRadius(20)
                    .padding(.horizontal, 35)
                    Spacer()
                    // The scroller is only horizontal for variety
                    // horizontal scroller with this many options may not provide the best user experience
                    ScrollView (.horizontal) {
                        LazyHStack {
                            ForEach(filteredDesserts) { dessert in
                                NavigationLink(destination: DessertDetailView(dessertID: dessert.id)) {
                                    VStack {
                                        Spacer()
                                        AsyncImage(url: dessert.image) { image in
                                            VStack {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                                                    .clipped()
                                                    .cornerRadius(25)
                                                Text(dessert.name.uppercased())
                                                    .fontWeight(.heavy)
                                            }
                                        } placeholder: {
                                            Spacer()
                                            ProgressView()
                                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                                                .clipped()
                                                .cornerRadius(20)
                                                .overlay(RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color.gray, lineWidth: 3)
                                                )
                                                .padding(.bottom)
                                            Spacer()
                                        }
                                        Spacer()
                                            .padding(.bottom)
                                    }
                                    .accessibilityIdentifier("DessertCell-\(dessert.id)")
                                    .accentColor(colorScheme == .dark ? Color.white : Color.black)
                                    .padding(.horizontal)
                                }
                                
                            }
                        }
                    }
                    .padding(.top, 40)
                    // This is simply to fill up empty space
                    // It provides a tip encouraging the user to swipe
                    VStack{
                        HStack{
                            Image(systemName: "arrow.left")
                                .foregroundColor(colorScheme == .dark ? Color(red: 100/255, green: 100/255, blue: 100/255) : .black)
                                .padding(.trailing, 10)
                            Text("Swipe")
                                .padding(10)
                            Image(systemName: "arrow.right")
                                .foregroundColor(colorScheme == .dark ? Color(red: 100/255, green: 100/255, blue: 100/255) : .black)
                                .padding(.leading, 10)
                        }
                    }
                }
                .background(Color(.secondarySystemBackground))
                .onAppear {
                    dessertViewModel.fetchDesserts()
                }
            }
        }
    }
}

struct DessertListView_Previews: PreviewProvider {
    static var previews: some View {
        DessertListView()
    }
}
