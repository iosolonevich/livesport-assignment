//
//  ContentView.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    let store: StoreOf<Search>
    @ObservedObject var viewStore: ViewStore<ViewState, Search.Action>
    
    struct ViewState: Equatable {
        let results: IdentifiedArrayOf<SearchResultDetail.State>
        var resultsBySport: Dictionary<String, IdentifiedArrayOf<SearchResultDetail.State>> = [:]
        let searchQuery: String
        let currentFilter: Search.SearchResultsFilter
        let isRequestInFlight: Bool

        init(state: Search.State) {
            self.results = state.results
            self.searchQuery = state.searchQuery
            self.currentFilter = state.currentFilter
            self.isRequestInFlight = state.isRequestInFlight
            
            self.resultsBySport = getGroupedSearchResults(for: state.results)
        }

        private func getGroupedSearchResults(
            for searchResults: IdentifiedArrayOf<SearchResultDetail.State>
        ) -> Dictionary<String, IdentifiedArrayOf<SearchResultDetail.State>> {
            guard !searchResults.isEmpty else { return [:] }
            let groupedResultsBySportDictionary = Dictionary(grouping: searchResults, by: { $0.searchResultDetail.sport.name.rawValue } )
            return Dictionary(
                uniqueKeysWithValues: groupedResultsBySportDictionary.map { key, value in
                    (key, IdentifiedArrayOf(uniqueElements: value))
                }
            )
        }
    }
    
    public init(store: StoreOf<Search>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: ViewState.init)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {

                searchBar
                
                resultCategoriesButtons
                
                resultsList
            }
            .navigationTitle("Livesport Search")
        }
        .alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
        .task(id: viewStore.searchQuery) {
            do {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC / 3)
                await viewStore.send(.searchQueryChangeDebounced(viewStore.currentFilter)).finish()
            } catch {
                // Ignore cancellation
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            if viewStore.isRequestInFlight {
                ProgressView()
                    .padding(.horizontal, 2)
            } else {
                Image(systemName: "magnifyingglass")
            }
                
            TextField(
                "Team, player, competition, ...",
                text: viewStore.binding(
                    get: \.searchQuery, send: Search.Action.searchQueryChanged
                )
            )
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var resultCategoriesButtons: some View {
        Picker("Filter", selection: viewStore.binding(get: \.currentFilter, send: Search.Action.filter)) {
            ForEach(Search.SearchResultsFilter.allCases, id: \.self) { filter in
                Text(filter.rawValue)
                    .tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var resultsList: some View {
        List {
            ForEach(Array(viewStore.resultsBySport.keys), id: \.self) { sportKey in
                Section(header: Text(sportKey)) {
                    ForEachStore(
                        self.store.scope(
                            state: { state in
                                viewStore.resultsBySport[sportKey] ?? IdentifiedArrayOf<SearchResultDetail.State>()
                            },
                            action: Search.Action.resultDetail(id:action:)
                        )
                    ) { sportStore in
                        SearchResultRowView(store: sportStore)
                            .buttonStyle(.borderless)
                    }
                }
            }
            
        }
        .listStyle(.insetGrouped)
    }
}

struct SearchResultRowView: View {
    let store: StoreOf<SearchResultDetail>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                NavigationLink(
                    destination: SearchResultDetailView(store: self.store)
                ) {
                    AsyncImage(
                        url: URL(string: "\(AppConstants.URLs.LivesportImageBaseUrl)/\(viewStore.searchResultDetail.images.first?.path ?? "")")
                    ) { image in
                        SearchResultImage(image: image)
                    } placeholder: {
                        SearchResultImageNotAvailable()
                    }

                    VStack(alignment: .leading) {
                        Text(viewStore.searchResultDetail.name)
                            .font(
                                .system(size: 14)
                            )
                            .bold()
                            .foregroundColor(.black)
                        
                        if let teamName = viewStore.searchResultDetail.teams?.first?.name {
                            Text(teamName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            store: Store(initialState: Search.State()) {
                Search()
            }
        )
    }
}
