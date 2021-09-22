//
//  MovieDetailModel.swift
//  SBTest
//
//  Created by Stockbit on 06/08/21.
//

import Foundation

struct MovieDetailModel {
    struct Response {
        var movie: Movie
    }
    
    struct ViewModel {
		var title : String
		var thumbnailPotrait : String
		var rating : String
		var genre : String
		var release : String
		var description : String
		var thumbnailLandscape : String
	}
}
