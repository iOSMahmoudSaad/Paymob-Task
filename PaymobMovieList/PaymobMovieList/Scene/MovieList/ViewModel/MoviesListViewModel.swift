//
//  MoviesListViewModel.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Combine
import Foundation

class MoviesListViewModel {
    // MARK: - Properties
    private let networkService: NetworkServiceType
    private let dbManager: DBManager
    private weak var coordinator: MoviesListCoordinator?
    
    @Published var isLoading = true
    @Published var isPaginating = false

    @Published var movies: [Movie] = []
    
    private var page: Int = 1
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(networkService: NetworkServiceType = NetworkService(),
         dbManager: DBManager = DBManager.shared,
         coordinator: MoviesListCoordinator) {
        self.networkService = networkService
        self.dbManager = dbManager
        self.coordinator = coordinator
        setupNotifications()
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func loadNowPlayingMovies(page: Int = 1) async throws -> MoviesListModel {
        await MainActor.run {
            isLoading = true
        }
        defer {
            Task { @MainActor in
                self.isLoading = false
            }
        }

        let parameters = ["page": "\(page)"]
        let endpoint = MovieEndpoint.discoverMovie(parameters: parameters)

        let response: MoviesListModel = try await networkService.request(endpoint: endpoint)
        updateMoviesWithFavoriteStatus(response.results)

        return response
    }

    
    func loadMoreMovies() {
        Task {
            do {
                let newPage = self.page + 1
                let parameters = ["page": "\(newPage)"]
                let endpoint = MovieEndpoint.discoverMovie(parameters: parameters)
                
                let response: MoviesListModel = try await networkService.request(endpoint: endpoint)
                let newMovies = applyFavoriteStatus(to: response.results)
                
                await MainActor.run {
                    self.movies.append(contentsOf: newMovies)
                    self.page = newPage
                }
            } catch {
                await MainActor.run {
                    self.page = -1
                }
            }
        }
    }
    
    func selectedMovie(at index: Int) -> Movie? {
        guard index >= 0, index < movies.count else { return nil }
        return movies[index]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return movies.count
    }
    
    func toggleFavorite(movie: Movie) -> Bool {
        let updatedMovie = movie
        updatedMovie.isFavorite.toggle()

        if updatedMovie.isFavorite {
            dbManager.saveFavorite(movie: updatedMovie)
        } else {
            dbManager.deleteFavorite(movie: updatedMovie)
        }

        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isFavorite = updatedMovie.isFavorite
            NotificationCenter.default.post(
                name: .favoriteState,
                object: updatedMovie
            )
        }
        
        return updatedMovie.isFavorite
    }
    
    func goToMovieDetails(movie: Movie) {
        coordinator?.goToMovieDetails(movie: movie)
    }
    
    // MARK: - Private Methods
    
    private func setupNotifications() {
        NotificationCenter.default.publisher(for: .favoriteState)
            .compactMap { $0.object as? Movie }
            .sink { [weak self] updatedMovie in
                self?.updateMovieInList(updatedMovie)
            }
            .store(in: &cancellables)
    }
    
    private func updateMovieInList(_ updatedMovie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == updatedMovie.id }) {
            movies[index].isFavorite = updatedMovie.isFavorite
        }
    }
    
    private func updateMoviesWithFavoriteStatus(_ newMovies: [Movie]) {
        let moviesWithFavorites = applyFavoriteStatus(to: newMovies)
        self.movies = moviesWithFavorites
    }
    
    private func applyFavoriteStatus(to movies: [Movie]) -> [Movie] {
        let fetchedFavorites = dbManager.fetchFavorites()
        let favoriteMovieIDs = Set(fetchedFavorites.compactMap { Int($0.id) })
        
        return movies.map { movie in
            let updatedMovie = movie
            if favoriteMovieIDs.contains(movie.id ?? 0) {
                updatedMovie.isFavorite = true
            }
            return updatedMovie
        }
    }
}

