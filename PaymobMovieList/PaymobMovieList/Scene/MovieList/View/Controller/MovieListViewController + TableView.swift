//
//  s.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import UIKit

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = viewModel?.movies[indexPath.row] else {
            return UITableViewCell()
        }
        let cell: MovieListCell = tableView.dequeue()
        
        let cellViewModel = MovieListCellViewModel(movie: movie)
        cell.configure(viewModel: cellViewModel)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewModel = viewModel, let movie = viewModel.selectedMovie(at: indexPath.row) {
            print(movie.isFavorite)
            viewModel.goToMovieDetails(movie: movie)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            if viewModel.movies.count > 19 && viewModel.movies.count - 4 == indexPath.row {
                viewModel.loadMoreMovies()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}


