//
//  Livesport_assignmentTests.swift
//  Livesport-assignmentTests
//
//  Created by Alex Solonevich on 03.08.2023.
//

import XCTest
import ComposableArchitecture

@testable import Livesport_assignment

@MainActor
final class Livesport_assignmentTests: XCTestCase {
    func testSearchQuery() async {
        let store = TestStore(initialState: Search.State()) {
            Search()
        } withDependencies: {
            $0.apiClient.searchQuery = { _, _ in [SearchResponseItem.mock] }
        }
        
        await store.send(.searchQueryChanged("Fils")) {
          $0.searchQuery = "Fils"
        }
        
        await store.send(.searchQueryChangeDebounced(.all)) {
            $0.isRequestInFlight = true
        }
        
        await store.receive(.searchResponse(.success([SearchResponseItem.mock]))) {
            $0.searchQuery = "Fils"
            $0.isRequestInFlight = false

            $0.results = IdentifiedArrayOf<SearchResultDetail.State>(
                uniqueElements: [SearchResponseItem.mock].map {
                    SearchResultDetail.State(searchResultDetail: $0)
                }
            )
        }
        
        await store.send(.searchQueryChanged("")) {
          $0.results = []
          $0.searchQuery = ""
            $0.isRequestInFlight = false
        }
    }
    
    func testSearchFailure() async {
        let store = TestStore(initialState: Search.State()) {
            Search()
        } withDependencies: {
            $0.apiClient.searchQuery = { _, _ in throw APIServiceError.invalidResponseType }
        }
        
        await store.send(.searchQueryChanged("Fils")) {
            $0.searchQuery = "Fils"
        }
        
        await store.send(.searchQueryChangeDebounced(.all)) {
            $0.isRequestInFlight = true
        }
        await store.receive(.searchResponse(.failure(APIServiceError.invalidResponseType))) {
            $0.isRequestInFlight = false
            $0.alert = AlertState {
                TextState(APIServiceError.invalidResponseType.localizedDescription)
            } actions: {
                ButtonState(role: .cancel, action: .send(.cancelButtonTapped, animation: .default)) {
                    TextState("Cancel")
                }
                ButtonState(role: .destructive, action: .send(.retryButtonTapped, animation: .default)) {
                    TextState("Retry")
                }
            }
        }
        await store.send(.alert(.presented(.cancelButtonTapped))) {
          $0.alert = nil
        }
    }
}

struct SomeResponseError: Equatable, Error {}
private enum SomeError: Error {
    case some
}
