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
        baseUrl defaultBaseUrl: URL = URL(string: "https://s.livesport.services/api/v2")!
    ) -> Self {
        return Self(
            baseUrl: {
                defaultBaseUrl
            },
            
            searchQuery: { query in
                guard var urlComponents = URLComponents(string: "\(defaultBaseUrl)/search") else {
                    throw APIServiceError.invalidURL
                }
                
                urlComponents.queryItems = [
                    URLQueryItem(name: "lang-id", value: "1"),
                    URLQueryItem(name: "project-id", value: "602"),
                    URLQueryItem(name: "project-type-id", value: "1"),
                    URLQueryItem(name: "sport-ids", value: "1,2,3,4,5,6,7,8,9"),
                    URLQueryItem(name: "type-ids", value: "1,2,3,4"),
                    URLQueryItem(name: "q", value: query),
                ]
                
                guard let url = urlComponents.url else {
                    throw APIServiceError.invalidURL
                }
                
                let (response, statusCode): ([SearchResponseItem], Int) = try await fetch(url: url)
//                TODO: handle the error
//                throw APIServiceError.httpStatusCodeFailed(statusCode: statusCode, error: error)


                return response
            }
        )
    }
}

private func fetch<D: Decodable>(url: URL) async throws -> (D, Int) {
    let (data, response) = try await URLSession.shared.data(from: url)
    let statusCode = try validateHTTPResponse(response: response)
    return (try JSONDecoder().decode(D.self, from: data), statusCode)
}

private func validateHTTPResponse(response: URLResponse) throws -> Int {
    guard let httpResponse = response as? HTTPURLResponse else {
        throw APIServiceError.invalidResponseType
    }
    
    guard 200...299 ~= httpResponse.statusCode || 400...499 ~= httpResponse.statusCode else {
        throw APIServiceError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: nil)
    }
    
    return httpResponse.statusCode
}
