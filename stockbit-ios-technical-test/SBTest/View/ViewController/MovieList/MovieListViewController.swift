import UIKit

protocol IMoviesViewController: AnyObject {
	func displaySuccesGetMoviesList(movies : MovieList )
	func displayErrorGetMoviesList(error : ErrorResult)
}

class MovieListViewController: UIViewController {
	
	// MARK: Private
	private var interactor: IMovieListInteractor?
	private let refreshControl = UIRefreshControl()
	
	@IBOutlet weak var tableView: UITableView!
	var spinner = UIActivityIndicatorView()
	
	var movieList : [MovieListModel.ViewModel.Movie] = []
	var loadingData = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = false
		setupNavigationItems()
		
		let nib = UINib.init(nibName: "MovieListTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "cell")
		
		setup()
		fetchMovie()
	}
	
	private func setup() {
		let presenter = MoviesListPresenter(view: self)
		interactor = MovieListInteractor(presenter: presenter, service: MovieService())
		
		tableView.delegate = self
		tableView.dataSource = self
		
		// Add Refresh Control to Table View
		if #available(iOS 10.0, *) {
			tableView.refreshControl = refreshControl
		} else {
			tableView.addSubview(refreshControl)
		}
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "loadingcell")
		
		// Configure Refresh Control
		refreshControl.addTarget(self, action: #selector(refreshMovieData(_:)), for: .valueChanged)
		refreshControl.attributedTitle = NSAttributedString(string: "Reloading Data ...")
		
		if movieList.isEmpty {
			tableView.separatorStyle = .none
		}
		hideTableViewLastSeparator()
	}
	
	private func setupNavigationItems() {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Movies"
		label.textAlignment = .left
		
		navigationItem.titleView = label
		if let navigationBar = navigationController?.navigationBar {
			label.widthAnchor.constraint(equalTo: navigationBar.widthAnchor, constant: -40).isActive = true
		}
	}
	
	@objc private func refreshMovieData(_ sender: Any) {
		// FetchData
		if !loadingData{
			setup()
			fetchMovie()
			
		}
		loadingData = true
	}
	
	
	private func fetchMovie() {
		//        #warning("Fetch from API")
		interactor?.fetchMovieList()
		
	}
	
	private func loadMoreData(){
		if !loadingData {
			interactor?.getNextPage()
		}
		loadingData = true
	}
	
	private func hideTableViewLastSeparator() {
		let footerView = UIView()
		footerView.translatesAutoresizingMaskIntoConstraints = false
		footerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		
		tableView.tableFooterView = footerView
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		
		if (offsetY > contentHeight - scrollView.frame.height * 4) && !loadingData {
			loadMoreData()
			loadingData = true
		}
	}
}

// MARK: - UITableViewDataSource

extension MovieListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return movieList.count
		} else if section == 1 {
			return 1
		} else {
			return 0
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//        #warning("Setup table view cell")
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieListTableViewCell
			cell.movie = movieList[indexPath.row]
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "loadingcell", for: indexPath)
			
			let txt = cell.textLabel
			txt?.text = " Loading.."
			txt?.textAlignment = .center
			txt?.textColor = .systemGray
			txt?.sizeToFit()
			
			return cell
		}
	}
}

// MARK: - UITableViewDelegate

extension MovieListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//		#warning("Handle didselect")
		let mv = interactor?.getMoviesEntity()
		let mvd = mv![indexPath.row]
		
		let vc = MovieDetailViewController()
		vc.movie = mvd
		vc.modalPresentationStyle = .fullScreen
		self.present(vc, animated: true, completion: nil)
	}
}

// MARK: - IMoviesPresenter

extension MovieListViewController: IMoviesViewController {
	func displayErrorGetMoviesList(error: ErrorResult) {
		print(error)
	}
	
	func displaySuccesGetMoviesList(movies : MovieList) {
		//        #warning("Handle to display view")
		DispatchQueue.main.async {
			self.movieList.removeAll()
			self.movieList = self.interactor?.getMoviesViewModel() ?? []
			self.tableView.reloadData()
			self.tableView.isHidden = false
			self.tableView.separatorStyle = .singleLine
			self.refreshControl.endRefreshing()
			self.loadingData = false
		}
		
	}
}
