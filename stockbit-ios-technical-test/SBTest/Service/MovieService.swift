import Foundation

protocol IMovieService {
    func requestMovieList(completion: ((Result<MovieList, ErrorResult>) -> Void)?)
    func loadMoreMovies(page: Int, completion: ((Result<MovieList, ErrorResult>) -> Void)?)
}

struct MovieService: IMovieService {
    private var api: BaseAPIService = BaseAPIService()
    
    func requestMovieList(completion: ((Result<MovieList, ErrorResult>) -> Void)?) {
        let urlString = Endpoint().path + "\(1)"
        api.request(urlString: urlString, completion: completion)
    }
    
    func loadMoreMovies(page: Int, completion: ((Result<MovieList, ErrorResult>) -> Void)?) {
        let urlString = Endpoint().path + "\(page)"
        api.request(urlString: urlString, completion: completion)
    }
}
