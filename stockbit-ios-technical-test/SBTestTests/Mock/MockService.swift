//
//  MockService.swift
//  SBTestTests
//
//  Created by Ridoan Wibisono on 21/09/21.
//

import Foundation
@testable import SBTest

class MockService : IMovieService {
	var fetchMoviesCalled = false
	var loadMoreMoviesCalled = false
	
	private var api = MockAPIService()
	func requestMovieList(completion: ((Result<MovieList, ErrorResult>) -> Void)?) {
		fetchMoviesCalled = true
		let url = Bundle(for: MockService.self).url(forResource: "movielist-success-response", withExtension: "json")
		api.request(url: url!, completion: completion)

	}
	
	func loadMoreMovies(page: Int, completion: ((Result<MovieList, ErrorResult>) -> Void)?) {
		loadMoreMoviesCalled = true
		let url = Bundle(for: MockService.self).url(forResource: "movielist-success-response", withExtension: "json")
		api.request(url: url!, completion: completion)
	}
	
}


class MockAPIService  {
	func request<T: Codable>(url: URL ,completion: ((_ result: Result<T, ErrorResult>) -> Void)? = nil) {
		
		let request = URLRequest(url: url)

		URLSession.shared.dataTask(with: request){ (data, response, error) in
			guard let data = data, error == nil else {
				completion?(.failure(ErrorResult.dataNil))
				return
			}
			
			do {
				let results = try JSONDecoder().decode(T.self, from: data)
				completion?(.success(results))
			} catch let decodingError {
				completion?(.failure(ErrorResult.generalError(message: decodingError.localizedDescription)))
			}
			
		}.resume()
	}
}
