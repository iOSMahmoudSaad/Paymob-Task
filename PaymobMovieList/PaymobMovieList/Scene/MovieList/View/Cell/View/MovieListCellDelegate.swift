//
//  MovieListCellDelegate.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//



protocol MovieListCellDelegate: AnyObject {
    
    func onTapFavoriteActionButton(in cell: MovieListCell)
}
