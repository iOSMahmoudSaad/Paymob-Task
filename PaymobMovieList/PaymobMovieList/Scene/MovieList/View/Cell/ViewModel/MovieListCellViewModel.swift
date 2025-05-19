//
//  MovieListCellViewModel.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

final class MovieListCellViewModel {
  
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.title
    }
    
    var date: String {
        return movie.releaseDate
    }
    
    var voteCount: String {
        return "Total Votes: \(movie.voteCount)"
    }
    
    var imageURL: String {
       
        return "\(APIConstants.imageURL)\(movie.posterPath)"
      
    }
    
    var rating: String {
        let formattedVoteAverage = String(format: "%.2f", movie.voteAverage ?? 0.0)
        return "Rating \(formattedVoteAverage) ⭐️"
    }
}
