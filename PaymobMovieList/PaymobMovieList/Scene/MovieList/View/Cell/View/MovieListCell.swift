//
//  MovieListCell.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import UIKit
import Combine

class MovieListCell: UITableViewCell {

    
    @IBOutlet weak var containerView: UIView!

    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var voteCountLabel: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    @IBOutlet private var ratingLabel: UILabel!
    
    weak var delegate: MovieListCellDelegate?
    
    var viewModel: MovieListCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configure(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        
        containerView.cornerRadius = 10
        containerView.borderWidth = 1
        containerView.borderColor = .systemBlue
        containerView.backgroundColor = .clear
        movieImageView.cornerRadius = 8
        titleLabel.textColor = .systemBlue
        [dateLabel, voteCountLabel, ratingLabel].forEach {
            $0.textColor = .systemGray
        }
        
    }

    public func configure(viewModel: MovieListCellViewModel) {
        
        Task { [weak self] in
              await self?.loadImage(imageURL: viewModel.imageURL)
          }
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        voteCountLabel.text = viewModel.voteCount
        ratingLabel.text = viewModel.rating
        favoriteButton.isSelected = viewModel.movie.isFavorite
        updateFavoriteButtonAppearance(isFavorite: viewModel.movie.isFavorite)
    }
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        delegate?.onTapFavoriteActionButton(in: self)
    }
    
    @MainActor
    func loadImage(imageURL: String) async {
        let image = await AsyncImageFetcher.loadImage(from: imageURL)
        movieImageView.image = image ?? UIImage(named: "image_placeholder")
    }
    
    func updateFavoriteButtonAppearance(isFavorite: Bool) {
        favoriteButton.isSelected = isFavorite
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
  
}
