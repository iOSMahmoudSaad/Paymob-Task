//
//  NetworkError.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Foundation

enum NetworkError: Error {
    case notConnected
    case invalidURL
    case invalidResponse
    case badRequest
    case unauthorized
    case serverError
    case notFound
    case unknownError(statusCode: Int?)

    var message: String {
        switch self {
        case .notConnected:
            return "No internet connection."
        case .invalidURL:
            return "Invalid request URL."
        case .invalidResponse:
            return "Invalid server response."
        case .badRequest:
            return "Bad request."
        case .unauthorized:
            return "Unauthorized access."
        case .serverError:
            return "Server error. Please try again later."
        case .notFound:
            return "Resource not found."
        case .unknownError(let statusCode):
            return "Unexpected error\(statusCode.map { " (code: \($0))" } ?? "")."
        }
    }
}
