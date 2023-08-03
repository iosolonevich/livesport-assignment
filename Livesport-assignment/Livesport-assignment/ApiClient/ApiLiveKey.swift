//
//  ApiLiveKey.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import ComposableArchitecture
import Foundation

extension ApiClient: DependencyKey {
    static let liveValue = Self.live()
    
    static func live(
        baseUrl defaultBaseUrl: URL? = URL(string: AppConstants.URLs.LivesportBaseUrl)
    ) -> Self {
        return Self(
            baseUrl: {
                guard let defaultBaseUrl else {
                    throw APIServiceError.invalidURL
                }
                return defaultBaseUrl
            },
            
            searchQuery: { query, filter in
                guard let defaultBaseUrl, var urlComponents = URLComponents(string: "\(defaultBaseUrl)/search") else {
                    throw APIServiceError.invalidURL
                }
                
                urlComponents.queryItems = [
                    URLQueryItem(name: "lang-id", value: "1"),
                    URLQueryItem(name: "project-id", value: "602"),
                    URLQueryItem(name: "project-type-id", value: "1"),
                    URLQueryItem(name: "sport-ids", value: "1,2,3,4,5,6,7,8,9"),
                    URLQueryItem(name: "type-ids", value: filter),
                    URLQueryItem(name: "q", value: query),
                ]
                
                guard let url = urlComponents.url else {
                    throw APIServiceError.invalidURL
                }
                
                return try await fetch(url: url)
            }
        )
    }
}

private func fetch<D: Decodable>(url: URL) async throws -> D {
    let (data, response) = try await URLSession.shared.data(from: url)
    try validateHTTPResponse(data: data, response: response)
    return try JSONDecoder().decode(D.self, from: data)
}

private func validateHTTPResponse(data: Data, response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
        throw APIServiceError.invalidResponseType
    }
    
    guard 200...299 ~= httpResponse.statusCode else {
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
        
        //TODO: Log detailed errorResponse, display basic info to user
        
        throw APIServiceError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: errorResponse)
    }
}
