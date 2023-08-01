//
//  ApiClient.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import ComposableArchitecture
import Foundation

struct ApiClient {
    var baseUrl: @Sendable () throws -> URL
    var searchQuery: @Sendable (String) async throws -> [SearchResponseItem]
}

extension ApiClient: TestDependencyKey {
    static let previewValue = Self(
        baseUrl: { URL(string: "https://s.livesport.services/api/v2")! },
        searchQuery: { _ in .mock }
    )
    
    static let testValue = Self(
        baseUrl: unimplemented("\(Self.self).baseUrl"),
        searchQuery: unimplemented("\(Self.self).searchQuery")
    )
}

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}
