import XCTest
@testable import SBTest

class MoviesInteractorTest: XCTestCase {
	
	
	// MARK:- Helper Property
	enum TestScenario {
		case success
		case failed
	}
	
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
	
	
	class MockMoviesPresenter : IMoviesPresenter {
		var presentSuccessGetMovieListCalled = false
		var presentErrorGetMoviesListCalled = false
		
		func presentSuccessGetMovieList(movies : MovieList){
			presentSuccessGetMovieListCalled = true
		}
		func presentErrorGetMoviesList(error : ErrorResult){
			presentErrorGetMoviesListCalled = true
		}
	}
	
	
	class MockMovieDataStore: IMovieService {
		var fetchMoviesCalled = false
		var loadMoreMoviesCalled = false
		
		let testScenario: TestScenario
		
		init(testScenario: TestScenario) {
			self.testScenario = testScenario
		}
		
		let mockResponse = MovieList(result: [Movie(title: "Batman", thumbnailPotrait: "", rating: "9.0", detail: Detail(genre: "Action", release: "2021", description: "Description", thumbnailLandscape: ""))], page: "1", length: "1")
		
		let errorResponse = ErrorResult.dataNil
		
		
		func requestMovieList(completion: ((Result<MovieList, ErrorResult>) -> Void)?) {
			fetchMoviesCalled = true
			if testScenario == .success {
				completion!(.success(mockResponse))
			} else {
				completion!(.failure(errorResponse))
			}
		}
		
		func loadMoreMovies(page: Int, completion: ((Result<MovieList, ErrorResult>) -> Void)?) {
			loadMoreMoviesCalled = true
			if testScenario == .success {
				completion!(.success(mockResponse))
			} else {
				completion!(.failure(errorResponse))
			}
		}
	}
	
	
	func testSuccessFetchMovie() {
		//		#warning("implement this unit test")
		let presenter = MockMoviesPresenter()
		let service = MockMovieDataStore(testScenario: .success)
		let interactor = MovieListInteractor(presenter: presenter, service: service)
		
		interactor.fetchMovieList()
		
		XCTAssert(service.fetchMoviesCalled, "Movie Service should fetch the movies from endpoint")
	}
	
	func testFailureFetchMovie() {
		//		#warning("implement this unit test")
		let presenter = MockMoviesPresenter()
		let service = MockMovieDataStore(testScenario: .failed)
		let interactor = MovieListInteractor(presenter: presenter, service: service)
		
		interactor.fetchMovieList()
		
		XCTAssert(service.fetchMoviesCalled, "Movie Service should not fetch the movie from endpoint")
		
		
		
	}
	
	func testAssertData() {
		//		#warning("implement this unit test")
		let service = MockMovieDataStore(testScenario: .success)
		
		service.requestMovieList { result in
			switch result {
			case .success(let res) :
				XCTAssertNotNil(res)
			case .failure :
				break
			}
			
			
		}
		
	}
	
	
}

