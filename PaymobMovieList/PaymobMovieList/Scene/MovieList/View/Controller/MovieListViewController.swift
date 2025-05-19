//
//  MovieListViewController.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import UIKit
import Combine

class MovieListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var viewModel: MoviesListViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: MoviesListViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var tableFooterView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = footerView.center
        indicator.startAnimating()
        footerView.addSubview(indicator)
        return footerView
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCell()
        fetchNowPlayingMovies()
        setupViewBinding()
        observeFavoriteStatusChanges()
    }
    
    
    private func setupViews() {
        title = NSLocalizedString("Trending Movie", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [
               .foregroundColor: UIColor.systemBlue
           ]
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    private func fetchNowPlayingMovies() {
        Task {
            do {
                try await viewModel?.loadNowPlayingMovies()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupViewBinding() {
        guard let viewModel = viewModel else { return }

        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.tableView.isHidden = true
                } else {
                    self.activityIndicator.stopAnimating()
                    self.tableView.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

    
    private func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellNib(cellClass: MovieListCell.self)
    }
    
    private func observeFavoriteStatusChanges() {
            NotificationCenter.default.publisher(for: .favoriteState)
                .sink { [weak self] notification in
                    guard let self = self,
                          let updatedMovie = notification.object as? Movie else { return }
                    if let index = self.viewModel?.movies.firstIndex(where: { $0.id == updatedMovie.id }) {
                        if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows,
                           let indexPath = visibleIndexPaths.first(where: { $0.row == index }) {
                            if let cell = self.tableView.cellForRow(at: indexPath) as? MovieListCell {
                                cell.updateFavoriteButtonAppearance(isFavorite: updatedMovie.isFavorite)
                            }
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }

extension MovieListViewController: MovieListCellDelegate {

    func onTapFavoriteActionButton(in cell: MovieListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let movie = viewModel?.movies[indexPath.row], let isFavorite = viewModel?.toggleFavorite(movie: movie){
            cell.updateFavoriteButtonAppearance(isFavorite: isFavorite)
        }
    }
}
