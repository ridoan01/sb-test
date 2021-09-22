//
//  MovieDetailPresenter.swift
//  MovieDetailPresenter
//
//  Created by Ari Munandar on 06/08/21.
//

import Foundation

protocol IMovieDetailPresenter: AnyObject {
    func presentMovieDetail(response: MovieDetailModel.Response)
}

class MovieDetailPresenter: IMovieDetailPresenter {
    private var view: IMovieDetailViewController?
    
    init(view: IMovieDetailViewController) {
        self.view = view
    }
    
    func presentMovieDetail(response: MovieDetailModel.Response) {
//        #warning("Handle to present movie detail")
		let movie = response.movie
		let movieMdl = MovieDetailModel.ViewModel(
			title: movie.title,
			thumbnailPotrait: movie.thumbnailPotrait,
			rating: movie.rating,
			genre: movie.detail.genre,
			release: movie.detail.release,
			description: movie.detail.description,
			thumbnailLandscape: movie.detail.thumbnailLandscape)
		
		view?.displayMovieDetail(viewModel: movieMdl)
    }
}
