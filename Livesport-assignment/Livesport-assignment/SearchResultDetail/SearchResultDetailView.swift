//
//  SearchResultDetailView.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 02.08.2023.
//

import ComposableArchitecture
import SwiftUI

struct SearchResultDetailView: View {
    let store: StoreOf<SearchResultDetail>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    AsyncImage(
                        url: URL(string: "\(AppConstants.URLs.LivesportImageBaseUrl)/\(viewStore.searchResultDetail.images.first?.path ?? "")")
                    ) { image in
                        SearchResultImage(image: image, height: 68)
                    } placeholder: {
                        SearchResultImageNotAvailable(width: 68, height: 68)
                    }

                    VStack {
                        Text(viewStore.searchResultDetail.name)
                        Text(viewStore.searchResultDetail.defaultCountry.name)
                    }
                }
                .padding(.bottom, 12)
                
                if let teams = viewStore.searchResultDetail.teams, !teams.isEmpty {
                    Text("Teams:")
                        .bold()
                    ForEach(teams, id: \.self) { team in
                        Text(team.name)
                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationTitle(viewStore.searchResultDetail.name)
        }
    }
}

struct SearchResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchResultDetailView(
                store: Store(
                    initialState: SearchResultDetail.State(
                        searchResultDetail: .mock
                    )
                ) {}
            )
        }
    }
}
