//
//  SearchResultDetail.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 02.08.2023.
//

import ComposableArchitecture
import Foundation

struct SearchResultDetail: Reducer {
    struct State: Equatable, Identifiable {
        var searchResultDetail: SearchResponseItem
        var id: String { self.searchResultDetail.id }
    }
    
    enum Action: Equatable {}
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}
