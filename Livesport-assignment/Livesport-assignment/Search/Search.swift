//
//  Search.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import ComposableArchitecture
import Foundation

struct Search: Reducer {
    enum SearchResultsFilter: String, CaseIterable, Hashable {
        case all = "All"
        case competitions = "Competitions"
        case participants = "Participants"
        
        func filterValue() -> String {
            switch self {
            case .all: return "1,2,3,4"
            case.competitions: return "1"
            case.participants: return "2,3,4"
            }
        }
    }
    
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.AlertAction>?
        var results: IdentifiedArrayOf<SearchResultDetail.State> = []
        var searchQuery = ""
        var currentFilter: SearchResultsFilter = .all
        var isRequestInFlight = false
    }
    
    enum Action: Equatable, BindableAction {
        case alert(PresentationAction<AlertAction>)
        case searchQueryChanged(String)
        case searchQueryChangeDebounced(SearchResultsFilter)
        case searchResponse(TaskResult<[SearchResponseItem]>)
        case resultDetail(id: SearchResultDetail.State.ID, action: SearchResultDetail.Action)
        case filter(SearchResultsFilter)
        case binding(BindingAction<State>)
    
        enum AlertAction: Equatable {
            case cancelButtonTapped
            case retryButtonTapped
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    private enum CancelID { case search }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case let .searchQueryChanged(query):
                state.searchQuery = query
                
                guard !query.isEmpty else {
                    state.results = []
                    return .cancel(id: CancelID.search)
                }
                return .none
                
            case let .searchQueryChangeDebounced(currentFilter):
                guard !state.searchQuery.isEmpty, state.searchQuery.count > 1 else {
                    return .none
                }
                state.isRequestInFlight = true
                return .run { [query = state.searchQuery] send in
                    await send(
                        .searchResponse(
                            TaskResult {
                                try await self.apiClient.searchQuery(query, currentFilter.filterValue())
                            }
                        )
                    )
                } catch: { error, send in
                    await send(
                        .searchResponse(.failure(error))
                    )
                }
                .cancellable(id: CancelID.search)
                
            case .searchResponse(.failure(APIServiceError.httpStatusCodeFailed(_, let errorResponse))):
                state.results = []
                state.isRequestInFlight = false
                state.alert = createErrorAlert(
                    with: errorResponse?.message ?? errorResponse?.errors?.first?.message ?? "Unknown error occured."
                )
                return .none
                
            case .searchResponse(.failure(let error)):
                state.results = []
                state.isRequestInFlight = false
                state.alert = createErrorAlert(with: error.localizedDescription)
                return .none
                
            case let .searchResponse(.success(response)):
                state.isRequestInFlight = false
                let searchResults = IdentifiedArrayOf<SearchResultDetail.State>(
                    uniqueElements: response.map {
                        SearchResultDetail.State(searchResultDetail: $0)
                    }
                )

                state.results = searchResults
                return .none
                
            case let .filter(filter):
                state.currentFilter = filter
                return .run { [filter = state.currentFilter] send in
                    await send(
                        .searchQueryChangeDebounced(filter)
                    )
                }
                .cancellable(id: CancelID.search)
                
            case .alert(.presented(.cancelButtonTapped)):
                state.alert = nil
                return .cancel(id: CancelID.search)
                
            case .alert(.presented(.retryButtonTapped)):
                state.alert = nil
                return .run { [filter = state.currentFilter] send in
                    await send(
                        .searchQueryChangeDebounced(filter)
                    )
                }
                .cancellable(id: CancelID.search)
                
            case .alert:
                return .none

            case .binding:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
        .forEach(\.results, action: /Action.resultDetail(id:action:)) {
            SearchResultDetail()
        }
    }
    
    private func createErrorAlert(with text: String) -> AlertState<Action.AlertAction> {
        AlertState {
            TextState(text)
        } actions: {
            ButtonState(role: .cancel, action: .send(.cancelButtonTapped, animation: .default)) {
                TextState("Cancel")
            }
            ButtonState(role: .destructive, action: .send(.retryButtonTapped, animation: .default)) {
                TextState("Retry")
            }
        }
    }
}
