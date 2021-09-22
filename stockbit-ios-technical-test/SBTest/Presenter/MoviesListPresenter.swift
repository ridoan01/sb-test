//
//  MoviesPresenter.swift
//  SBTest
//
//  Created by Stockbit on 06/08/21.
//

import Foundation

protocol IMoviesPresenter {
	func presentSuccessGetMovieList(movies : MovieList)
	func presentErrorGetMoviesList(error : ErrorResult)
}

class MoviesListPresenter: IMoviesPresenter {
    // MARK: Private
    private weak var view: IMoviesViewController?
    
    init(view: IMoviesViewController) {
        self.view = view
    }

    // MARK: Internal

	func presentSuccessGetMovieList(movies : MovieList) {
        view?.displaySuccesGetMoviesList(movies: movies)
    }

	func presentErrorGetMoviesList(error : ErrorResult) {
		view?.displayErrorGetMoviesList(error: error)
	}
}
