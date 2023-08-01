//
//  ContentView.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    let store: StoreOf<Main>
    @ObservedObject var viewStore: ViewStore<Main.State, Main.Action>
    
    public init(store: StoreOf<Main>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 } )
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {

                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(
                        "Team, player, contest, ...",
                        text: viewStore.binding(
                            get: \.searchQuery, send: Main.Action.searchQueryChanged
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                List {
                    ForEach(getGroupedSearchResults(for: viewStore.results), id: \.self) { resultsForSport in
                        Section(header: Text(resultsForSport.first?.sport.name.rawValue ?? "Unknown sport")) {
                            ForEach(resultsForSport) { result in
                                Button {
                                    viewStore.send(.searchResultTapped(result))
                                } label: {
                                    searchResultRowView(for: result)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Livesport Search")
        }
        .task(id: viewStore.searchQuery) {
            do {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC / 3) //TODO: another way
                await viewStore.send(.searchQueryChangeDebounced).finish()
            } catch {

            }
        }
    }

    func searchResultRowView(for result: SearchResponseItem) -> some View {
        HStack {
            AsyncImage(
                url: URL(string: "\(AppConstants.URLs.LivesportImageBaseUrl)/\(result.images.first?.path ?? "")")
            ) { image in
                image
                    .resizable()
                    .padding(4)
            } placeholder: {
                Image("placeholder-not-available")
                    .resizable()
            }
            .scaledToFit()
            .frame(width: 32, height: 32)
            .border(.gray, width: 1)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(result.name)
                    .font(
                        .system(size: 14)
                    )
                    .bold()
                    .foregroundColor(.black)
                
                if let teamName = result.teams?.first?.name {
                    Text(teamName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
        }
    }
}

private func getGroupedSearchResults(for searchResults: [SearchResponseItem]) -> [[SearchResponseItem]] {
    guard !searchResults.isEmpty else { return [] }
    let groupedResultsBySportDictionary = Dictionary(grouping: searchResults, by: { $0.sport.name } )
    return SportName.allCases.compactMap( { groupedResultsBySportDictionary[$0] } )
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store(initialState: Main.State()) {
                Main()
            }
        )
    }
}
