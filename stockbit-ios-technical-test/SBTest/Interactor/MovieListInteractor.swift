import Foundation

protocol IMovieListInteractor {
	func fetchMovieList()
	func getMoviesCount() -> Int
	func getMoviesViewModel() -> [MovieListModel.ViewModel.Movie]
	func getMoviesEntity() -> [Movie]
	func getNextPage()
}

class MovieListInteractor: IMovieListInteractor {
	
	// MARK: Private
	private let service: IMovieService
	private let presenter: IMoviesPresenter
	
	private var movieList : MovieList?
	
	// MARK: Lifecycle
	
	init(presenter: IMoviesPresenter, service: IMovieService) {
		self.presenter = presenter
		self.service = service
	}
	
	// MARK: Internal
	
	func fetchMovieList(){
		//        #warning("Handle API Response")
		service.requestMovieList { result in
			switch result {
			case .success(let resp) :
				self.movieList = resp
				self.presenter.presentSuccessGetMovieList(movies : resp)
			case .failure(let error):
				self.presenter.presentErrorGetMoviesList(error: error)
			}
			
		}
		
	}
	
	func getMoviesEntity() -> [Movie] {
		//        #warning("Fix Me")
		var movie = [Movie]()
		if let mv = movieList?.result {
			for i in mv.indices {
				movie.append(
					Movie(
						title: mv[i].title,
						thumbnailPotrait: mv[i].thumbnailPotrait,
						rating: mv[i].rating,
						detail:
							Detail(
								genre: mv[i].detail.genre,
								release: mv[i].detail.release,
								description: mv[i].detail.description,
								thumbnailLandscape: mv[i].detail.thumbnailLandscape)))
			}
		}
		return movie
	}
	
	func getMoviesCount() -> Int {
		//        #warning("Fix Me")
		return movieList?.result.count ?? 0
	}
	
	func getMoviesViewModel() -> [MovieListModel.ViewModel.Movie] {
		//        #warning("Fix Me")
		var movie : [MovieListModel.ViewModel.Movie] = []
		let mv = movieList?.result ?? []
		for i in mv.indices {
			movie.append(MovieListModel.ViewModel.Movie(
							title: mv[i].title,
							thumbnailPotrait: mv[i].thumbnailPotrait,
							rating: mv[i].rating,
							release: mv[i].detail.release,
							description: mv[i].detail.description))
		}
		return movie
	}
	
	func getNextPage() {
		//		#warning("Load More")
		let nextPage = ((movieList?.page ?? "1") as NSString).intValue + 1
		
		service.loadMoreMovies(page: Int(nextPage)) { Result in
			switch Result {
			case.success(let resp) :
				self.movieList?.result += resp.result
				self.movieList?.page = resp.page
				self.presenter.presentSuccessGetMovieList(movies: resp)
			case.failure(let error) :
				self.presenter.presentErrorGetMoviesList(error: error)
			}
		}
	}
}

