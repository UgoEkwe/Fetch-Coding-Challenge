//
//  DessertDetailView.swift
//  Fetch Coding Challenge
//
//  Created by Ugonna Oparaochaekwe on 7/11/23.
//
// Design Inspired by: https://dribbble.com/shots/20792040-Cookpedia-Food-Recipe-Mobile-App

import SwiftUI

/* The `DessertDetailView` struct shows detailed information about a specific dessert.
It takes `dessertID` as input which is then used to fetch the detailed information.
The observed object `dessertDetailViewModel` is used to retreive the dessert detail data from the data source.
The detail data is fetched when the view appears.
A pseudo-modal is presented once the detail data has been retreived and displays the data.
The struct originally presented a sheet with .medium presentation indents but after issues implementing the 'back' button
I decided to go with a pseudo-modal instead.
Includes an Accessibility Identifier for UI Tests
The design for this view was inspired by https://dribbble.com/shots/20792040-Cookpedia-Food-Recipe-Mobile-App*/

struct DessertDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    let dessertID: String
    @ObservedObject var dessertDetailViewModel = DessertDetailViewModel()
    @State private var dessertInfo: DessertDetail?
    @State private var presentModal = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                VStack (alignment: .center){
                    // If the dessert details are fetched, display the image.
                    // Image should present as a full background behind the modal
                    if let dessertDetail = dessertDetailViewModel.dessertDetail {
                        VStack{
                            AsyncImage(url: dessertDetail.image) { image in
                                VStack {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width, height: 450)
                                        .clipped()
                                        .cornerRadius(20)
                                        .overlay(RoundedRectangle(cornerRadius: 15)
                                            .stroke(LinearGradient(colors: [.clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 7)
                                        )
                                        .padding(.bottom)
                                }
                            } placeholder: {
                                // If the dessert image isn't fetched yet, display a loading indicator.
                                VStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            }
                        }
                    } else {
                        // If the dessert details aren't fetched yet, display a loading indicator.
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .background(Color.clear)
                .zIndex(0)
                if presentModal {
                    DessertDetailModal(dessertDetail: dessertDetailViewModel.dessertDetail!, difficulty: dessertDetailViewModel.difficulty)
                        .background(Color(.secondarySystemBackground))
                        .frame(height: geometry.size.height * 0.7)
                        .cornerRadius(20)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                        .offset(y: geometry.size.height * 0.45)
                }
                Button(action: {
                    //Dismiss the modal first so dessertDetail does not become nil
                    presentModal = false
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundColor(colorScheme == .dark ? Color(.secondarySystemBackground) : .white)
                        Image(systemName: "arrow.left")
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
                .padding()
                .padding(.top,20)
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                dessertDetailViewModel.fetchDessertDetail(for: dessertID)
            }
            .onChange(of: dessertDetailViewModel.detailsFetched) { newValue in
                // Present the modal only when the data has been retreived
                if newValue {
                    withAnimation {
                        presentModal = true
                    }
                }
            }
        }
    }
}

/* The `DessertDetailModal` struct shows the detail data of a dessert in a pseudo-modal format.
The detail data shown includes, meal name, instructions, and ingredients/measures.
It takes `dessertDetail` and `difficulty` as inputs. `dessertDetail` contains the detailed information of the dessert,
and `difficulty` indicates the difficulty level of preparing the dessert.
For each ingredient, a thumbnail stored in the imageURL property of the ingredient is loaded asynchronously. If the image is not yet loaded or nothing is found, it displays progress indicators.
The design for this view was inspired by https://dribbble.com/shots/20792040-Cookpedia-Food-Recipe-Mobile-App*/

struct DessertDetailModal: View {
    @Environment(\.dismiss) var dismiss
    let dessertDetail: DessertDetail
    let difficulty: Difficulty
    
    var body: some View {
        ScrollView {
            Spacer()
            HStack{
                VStack (alignment: .leading){
                    Text(dessertDetail.name)
                        .accessibilityIdentifier("DetailTitle")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.trailing)
                    Text("\(dessertDetail.region)")
                        .foregroundColor(Color.gray)
                        .font(.headline)
                }
                Spacer()
                VStack (alignment: .trailing){
                    VStack (alignment: .center){
                        // Display indicator of difficulty based on the value and description set in DessertDetailViewModel
                        HStack {
                            ForEach(0..<difficulty.rawValue, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(difficulty == .easy ? Color.green : difficulty == .medium ? Color.orange : Color.red)
                            }
                        }
                        .font(.headline)
                        Text(difficulty.description)
                            .foregroundColor(Color.gray)
                            .font(.headline)
                    }
                }
            }
            .padding(.bottom, 10)
            Spacer()
            VStack(alignment: .leading) {
                Text("Ingredients")
                    .font(.headline)
                    .fontWeight(.black)
                    .padding(.bottom, 5)
                ForEach(dessertDetail.ingredients, id: \.name) { ingredient in
                    HStack {
                        // Asynchronosly load the thumbnail stored in the imageURL property of the ingredient
                        // If not yet loaded display progress view, if nothign found display X
                        VStack{
                            if let imageUrl = ingredient.imageURL {
                                AsyncImage(url: imageUrl, transaction: Transaction(animation: .spring())) { phase in
                                    switch phase {
                                    case .success(let image):
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(red: 200/255, green: 200/255, blue: 200/255))
                                                .frame(width: 50, height: 50)
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(10)
                                                .frame(width: 45, height: 45)
                                        }
                                    case .failure, .empty:
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.mint, lineWidth: 2)
                                                .frame(width: 50, height: 50)
                                            Text("X")
                                                .frame(width: 45, height: 45)
                                                .foregroundColor(Color.red)
                                        }
                                    default:
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.mint, lineWidth: 2)
                                                .frame(width: 50, height: 50)
                                            ProgressView()
                                        }
                                    }
                                }
                            }
                        }
                        Text("\(ingredient.name)")
                            .font(.body)
                        Spacer()
                        Text("\(ingredient.measure)")
                            .font(.body)
                    }
                }
            }
            .padding(.bottom, 15)
            Spacer()
            VStack(alignment: .leading){
                Text("Instructions")
                    .font(.headline)
                    .fontWeight(.black)
                    .padding(.bottom, 5)
                Text(dessertDetail.instructions)
            }
            // Added padding here to protect the description from lower screen bounds
            .padding(.bottom, 45)
            Spacer()
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .padding(.top, 35)
        .interactiveDismissDisabled()
    }
}
