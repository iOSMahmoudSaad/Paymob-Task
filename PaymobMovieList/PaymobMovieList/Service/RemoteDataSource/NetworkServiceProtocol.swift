//
//  NetworkServiceProtocol.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//



protocol NetworkServiceType {
    func request<T: Codable>(endpoint: any Endpoint) async throws -> T
}

protocol Endpoint {
    
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String] { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"

}
