import UIKit
import Kingfisher

protocol IMovieDetailViewController: AnyObject {
	func displayMovieDetail(viewModel: MovieDetailModel.ViewModel)
}

class MovieDetailViewController: UIViewController {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var rating : UILabel!
	@IBOutlet weak var date : UILabel!
	@IBOutlet weak var desc : UILabel!
	@IBOutlet weak var genre : UILabel!
	@IBOutlet weak var poster : UIImageView!
	@IBOutlet weak var star1 : UIImageView!
	@IBOutlet weak var star2 : UIImageView!
	@IBOutlet weak var star3 : UIImageView!
	@IBOutlet weak var star4 : UIImageView!
	@IBOutlet weak var star5 : UIImageView!
	
	private var interactor: IMovieDetailInteractor!
	
	var movie : Movie?
	
	convenience init(movie: Movie) {
		let bundle = Bundle(for: type(of: self))
		self.init(nibName: "MovieDetailViewController", bundle: bundle)
		setup(movie: movie)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true
		addBackButton()
		setup(movie: movie!)
		
	}
	
	func addBackButton() {
		let backButton = UIButton(type: .custom)
		backButton.setImage(UIImage(named: "close"), for: .normal)
		backButton.setTitleColor(backButton.tintColor, for: .normal)
		backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
		backButton.backgroundColor = UIColor.white
		backButton.frame = CGRect(x: 20, y: 40, width: 30, height: 30)
		backButton.layer.cornerRadius = 15
		
		view.addSubview(backButton)
		
		
	}
	
	@IBAction func backAction(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	private func setup(movie: Movie) {
		let presenter = MovieDetailPresenter(view: self)
		interactor = MovieDetailInteractor(presenter: presenter, movie: movie)
		
		interactor.handleMovieDetail()
	}
	
	
	
}

extension MovieDetailViewController: IMovieDetailViewController {
	func displayMovieDetail(viewModel: MovieDetailModel.ViewModel) {
		//        #warning("Fix this function")
		titleLabel.text = viewModel.title
		date.text = viewModel.release
		rating.text = viewModel.rating
		genre.text = viewModel.genre
		desc.text = viewModel.description
		
		setupStars(str: viewModel.rating)
		setupPoster(str : viewModel.thumbnailLandscape)
	}
}


extension MovieDetailViewController {
	
	func setupStars(str : String) {
		let allStar = [star1,star2,star3,star4,star5]
		let starInt  =  (str as NSString).integerValue / 2
		
		for i in 0..<starInt{
			allStar[i]?.image = UIImage(named: "Star Fill")
		}
	}
	
	func setupPoster(str : String){
		let url = URL(string: str)
		let cache = ImageCache.default
		let resource = ImageResource(downloadURL: url!, cacheKey: str)
		
		let processor = DownsamplingImageProcessor(size: poster.bounds.size)
			|> RoundCornerImageProcessor(cornerRadius: 0)
	
		poster.kf.indicatorType = .activity
		poster.kf.setImage(
			with: resource,
			options: [
				.processor(processor),
				.transition(.fade(1)),
				.cacheOriginalImage,
				.targetCache(cache),
				.memoryCacheExpiration(.seconds(30))
				
			])
		
	}
	
}
