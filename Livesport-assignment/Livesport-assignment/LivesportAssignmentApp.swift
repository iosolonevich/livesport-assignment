//
//  LivesportAssignmentApp.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct LivesportAssignmentApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(
                store: Store(initialState: Search.State(), reducer: {
                    Search()
                })
            )
        }
    }
}
