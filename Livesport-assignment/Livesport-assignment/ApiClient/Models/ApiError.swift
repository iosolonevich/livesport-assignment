//
//  ApiError.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import Foundation

struct ErrorResponse: Decodable, Equatable {
    let code: Int
    let message: String
    let name: String
    let stack: String?
    let errors: [LSError]?
}

struct LSError: Decodable, Equatable {
    let message: String
    let type: String
}

enum APIServiceError: Error, Equatable {
    case invalidURL
    case invalidResponseType
    case httpStatusCodeFailed(statusCode: Int, error: ErrorResponse?)
}
