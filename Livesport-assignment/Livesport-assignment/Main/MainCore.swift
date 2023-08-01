//
//  MainCore.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import ComposableArchitecture
import Foundation

struct Main: Reducer {
    struct State: Equatable {
        var results: [SearchResponseItem] = []
        var searchQuery = ""
        var resultRequestInProgress: SearchResponseItem?
    }
    
    enum Action: Equatable {
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(TaskResult<[SearchResponseItem]>)
        case searchResultTapped(SearchResponseItem)
    }
    
    @Dependency(\.apiClient) var apiClient
    private enum CancelID { case search }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        case let .searchQueryChanged(query):
            state.searchQuery = query
            
            guard !query.isEmpty else {
                state.results = []
                return .cancel(id: CancelID.search)
            }
            return .none
            
        case .searchQueryChangeDebounced:
            guard !state.searchQuery.isEmpty else {
                return .none
            }
            return .run { [query = state.searchQuery] send in
                await send(
                    .searchResponse(
                        TaskResult {
                            try await self.apiClient.searchQuery(query)
                        }
                    )
                )
            }
            .cancellable(id: CancelID.search)
            
        case let .searchResponse(.failure(error)):
            state.results = []
            //TODO: handle the error
            return .none
            
        case let .searchResponse(.success(response)):
            state.results = response
            return .none
            
        case let .searchResultTapped(result):
            //TODO: open details
            print("\(result.name) was tapped")
            return .none
        }
    }
}
