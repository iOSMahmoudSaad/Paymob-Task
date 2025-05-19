//
//  Constants.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Foundation

 
struct APIConstants {
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "20fce186ae942f3cf318dcaec5791f8f"
    static let imageURL = "https://image.tmdb.org/t/p/w500/"

    static private  let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMGZjZTE4NmFlOTQyZjNjZjMxOGRjYWVjNTc5MWY4ZiIsIm5iZiI6MTc0NzMyMzQ0MS42ODMsInN1YiI6IjY4MjYwYTMxYmY4N2ZjNDM3MDJkMmQ4ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Z82zrloxP9rhktSj5E2HfRc_cYXJ7mzIyvmi7i5jEI4"
    
    
    struct HeaderKeys {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    struct HeaderValues {
        static let applicationJSON = "application/json"
        static let bearer = "Bearer \(accessToken)"
    }
    
    struct Parameters {
        static let language = "language"
        static let limit = "limit"
        static let apiKey = "api_key"
    }
    
    struct DefaultValues {
        static let language = "en-US"
        static let limit = "10"
    }
}
