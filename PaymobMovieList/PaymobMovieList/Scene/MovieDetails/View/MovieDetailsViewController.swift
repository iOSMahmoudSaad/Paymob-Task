//
//  MovieDetailsViewController.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseNoteLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var overviewTextView: UITextView!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var orginalLanguage: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var favoriteButton: UIButton!
    var viewModel: MovieDetailsViewModel?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: MovieDetailsViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }

    private func setupViews() {
        navigationController?.navigationBar.tintColor = .systemBlue
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        releaseNoteLabel.text = viewModel.releaseDate
        ratingLabel.text = viewModel.rating
        orginalLanguage.text = viewModel.orginalLanguage
        overViewLabel.text = "Description"
        overviewTextView.text = viewModel.overview
        activityIndicator.startAnimating()
        
        Task { [weak self] in
              await self?.loadMovieImage(from: viewModel.imageURL)
          }
    }
    
    @MainActor
    private func loadMovieImage(from urlString: String) async {
        activityIndicator.startAnimating()
        let image = await AsyncImageFetcher.loadImage(from: urlString)
        activityIndicator.stopAnimating()
        movieImageView.image = image ?? UIImage(named: "image_placeholder")
    }
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        viewModel?.toggleFavorite()
    }

    private func updateFavoriteButtonAppearance(isFavorite: Bool) {
        favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
    
    private func bindViewModel() {
        viewModel?.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                self?.updateFavoriteButtonAppearance(isFavorite: isFavorite)
            }
            .store(in: &cancellables)
    }
}

