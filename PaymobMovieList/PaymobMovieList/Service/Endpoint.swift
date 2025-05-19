//
//  Endpoint.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

enum MovieEndpoint: Endpoint {
    
    case discoverMovie(parameters: [String: String])
    
    var path: String {
        switch self {
        case .discoverMovie:
            return "/discover/movie"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .discoverMovie:
            return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .discoverMovie(let parameters):
            return parameters
        }
    }
}
