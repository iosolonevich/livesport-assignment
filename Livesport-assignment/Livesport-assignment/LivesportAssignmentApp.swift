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
            MainView(
                store: Store(initialState: Main.State(), reducer: {
                    Main()
                })
            )
        }
    }
}
