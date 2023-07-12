# Fetch-Coding-Challenge

This is an iOS coding challenge project which fetches a list of dessert recipes from an API and displays them in alphabetical order.

## Requirements

To run this project, you need:

* Xcode 13 or higher.
* A device running iOS 16 or higher, or an equivalent simulator.

## Setup

This project relies on the TheMealDB API for fetching the recipes. To use this API, you need an API key.

Follow these steps to set up the project:

1. Get your API key from [TheMealDB](https://www.themealdb.com/api.php).
2. Create an APIKeys.plist file in the root directory of the project.
3. In the APIKeys.plist file, add a new entry. Set the key to "TheMealDB" and the value to your API key from step 1.
4. Ensure that the APIKeys.plist file is added to your .gitignore file to prevent it from being committed to your repository.

## Running the Project

Once the setup steps are complete, you can run the project in Xcode.

* Select your target device in the device list (it should be running iOS 16 or higher).
* Click the 'Run' button or press Cmd + R to build and run the project.

## Running Unit and UI Tests
This project includes unit and UI tests to ensure the functionality of core components and interactions. They are designed to test data fetching, filtering, and the user interface.

To run the tests:

Open the project in Xcode.
Select Product > Test or press Cmd + U. This will build the project and run the test suite.
