import Foundation

struct MovieListModel {
	
	struct Response {
		var movieList : MovieList
	}
	
    struct ViewModel {
        
        struct Movie {
			var title : String
			var thumbnailPotrait : String
			var rating : String
			var release : String
			var description : String
        }
    }
}
