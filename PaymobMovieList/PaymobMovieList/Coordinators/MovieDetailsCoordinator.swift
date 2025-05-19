//
//  MovieDetailsCoordinator.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Foundation
import UIKit

final class MovieDetailsCoordinator: BaseCoordinator {
    
    private let movie: Movie
    
    init(navigationController: UINavigationController, movie: Movie) {
        self.movie = movie
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        
        let moviesDetailsViewModel = MovieDetailsViewModel(coordinator: self, movie: movie)
        let moviesDetailsVC = MovieDetailsViewController(
            viewModel: moviesDetailsViewModel,
            nibName: MovieDetailsViewController.typeName
        )
        navigationController.pushViewController(moviesDetailsVC, animated: true)
    }
}
