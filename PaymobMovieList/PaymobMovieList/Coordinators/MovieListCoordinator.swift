//
//  MovieListCoordinator.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Foundation
import UIKit

final class MoviesListCoordinator: BaseCoordinator {

    override func start() {
        let moviesListViewModel = MoviesListViewModel(coordinator: self)
        let moviesListVC = MovieListViewController(
            viewModel: moviesListViewModel,
            nibName: MovieListViewController.typeName  )
        navigationController.setViewControllers([moviesListVC], animated: true)
    }

    func goToMovieDetails(movie: Movie) {
      
        let movieDetailsCoordinator = MovieDetailsCoordinator(
            navigationController: navigationController,
            movie: movie
        )
        addChildCoordinator(movieDetailsCoordinator)
        movieDetailsCoordinator.start()
    }
}
