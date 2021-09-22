//
//  MovieListTableViewCell.swift
//  SBTest
//
//  Created by Stockbit on 06/08/21.
//

import UIKit
import Kingfisher

final class MovieListTableViewCell: UITableViewCell {
	@IBOutlet weak var title : UILabel!
	@IBOutlet weak var rating : UILabel!
	@IBOutlet weak var date : UILabel!
	@IBOutlet weak var desc : UILabel!
	@IBOutlet weak var poster : UIImageView!
	@IBOutlet weak var star1 : UIImageView!
	@IBOutlet weak var star2 : UIImageView!
	@IBOutlet weak var star3 : UIImageView!
	@IBOutlet weak var star4 : UIImageView!
	@IBOutlet weak var star5 : UIImageView!
	
	
	
	
	var movie : MovieListModel.ViewModel.Movie? {
		didSet{
			title.text = movie?.title
			rating.text = movie?.rating
			date.text = movie?.release
			desc.text = movie?.description
			
			setPoster(str: movie?.thumbnailPotrait ?? "")
			
			let stars = movie?.rating
			star(str : stars!)
		}
	}
	
	override func awakeFromNib() {
	super.awakeFromNib()
	// Initialization code
		setup()
	}
	
	func setup() {
		title.adjustsFontSizeToFitWidth = true
		desc.numberOfLines = 3
	}
	
	func star(str : String) {
		let allStar = [star1,star2,star3,star4,star5]
		for i in allStar.indices{
			allStar[i]?.image = UIImage(named: "Star Empty")
		}
		
		let starInt  =  (str as NSString).integerValue / 2
		
		for i in 0..<starInt{
			allStar[i]?.image = UIImage(named: "Star Fill")
		}
		
	}
	
	func setPoster(str : String){
		
		poster.layer.cornerRadius = 8
		let url = URL(string: str)
		
		let cache = ImageCache.default
		let resource = ImageResource(downloadURL: url!, cacheKey: str)
		
		let processor = DownsamplingImageProcessor(size: poster.bounds.size)
			|> RoundCornerImageProcessor(cornerRadius: 0)
	
		poster.kf.indicatorType = .activity
		poster.kf.setImage(
			with: resource,
			placeholder: UIImage(systemName: "line.3.crossed.swirl.circle.fill"),
			options: [
				.processor(processor),
				.transition(.fade(1)),
				.cacheOriginalImage,
				.targetCache(cache),
				.memoryCacheExpiration(.seconds(30))
				
			])
		cache.memoryStorage.config.totalCostLimit = 30 * 1024 * 1024
		cache.memoryStorage.config.countLimit = 50
		
		let frontimg = UIImage(named: "Play Small") // The image in the foreground
		let frontimgview = UIImageView(image: frontimg) // Create the view holding the image
		
		poster.addSubview(frontimgview)
		frontimgview.center = poster.convert(poster.center, from:poster.superview)
	}
	
}
