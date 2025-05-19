//
//  MoviesListModel.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Foundation

class MoviesListModel: Codable {
    var dates: Dates?
    var page: Int?
    let results: [Movie]
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(dates: Dates? = nil, page: Int? = nil, results: [Movie], totalPages: Int? = nil, totalResults: Int? = nil) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Dates
class Dates: Codable {
    let maximum, minimum: String

    init(maximum: String, minimum: String) {
        self.maximum = maximum
        self.minimum = minimum
    }
}

// MARK: - Movie
class Movie: Codable, Hashable, Equatable {
    let uuid = UUID().uuidString
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]
    var id: Int?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String
    var popularity: Double?
    var posterPath, releaseDate, title: String
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int
    var isFavorite: Bool = false
    
      enum CodingKeys: String, CodingKey {
          case adult
          case backdropPath = "backdrop_path"
          case genreIDS = "genre_ids"
          case id
          case originalLanguage = "original_language"
          case originalTitle = "original_title"
          case overview, popularity
          case posterPath = "poster_path"
          case releaseDate = "release_date"
          case title, video
          case voteAverage = "vote_average"
          case voteCount = "vote_count"
      }
    
    init(adult: Bool? = nil,
         backdropPath: String,
         genreIDS: [Int],
         id: Int? = nil,
         originalLanguage: String? = nil,
         originalTitle: String? = nil,
         overview: String,
         popularity: Double? = nil,
         posterPath: String,
         releaseDate: String,
         title: String,
         video: Bool? = nil,
         voteAverage: Double? = nil,
         voteCount: Int,
         isFavorite:Bool = false ) {
        
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isFavorite = isFavorite
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
