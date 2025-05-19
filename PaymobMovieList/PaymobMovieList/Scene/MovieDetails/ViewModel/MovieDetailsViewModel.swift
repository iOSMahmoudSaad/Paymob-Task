//
//  Untitled.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Combine
import Foundation

class MovieDetailsViewModel {
    
    private let storageManager = DBManager.shared

    weak var coordinator: MovieDetailsCoordinator?
    private var movie: Movie
    @Published var isFavorite: Bool
    private var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: MovieDetailsCoordinator? = nil, movie: Movie) {
        self.coordinator = coordinator
        self.movie = movie
        self.isFavorite = movie.isFavorite
    }
    
    var title: String {
        return movie.title
    }
    
    var overview: String {
        return movie.overview
    }
    
    
    var releaseDate: String {
        return "Release Date: " + movie.releaseDate
    }
    
    var imageURL: String {
        
        return "\(APIConstants.imageURL)" + (movie.backdropPath ?? "")
        
    }
    
    var rating: String {
        let formattedVoteAverage = String(format: "%.2f", movie.voteAverage ?? 0.0)
        return "Rate : \(formattedVoteAverage) 🌟"
    }
    
    var orginalLanguage: String {
        
        return "Language: " + (movie.originalLanguage ?? "")
    }
    
    func toggleFavorite() {
        
        isFavorite.toggle()
        movie.isFavorite = isFavorite
        if isFavorite {
            storageManager.saveFavorite(movie: movie)
        } else {
            storageManager.deleteFavorite(movie: movie)
        }
        NotificationCenter.default.post(name: .favoriteState, object: movie)
    }
}
