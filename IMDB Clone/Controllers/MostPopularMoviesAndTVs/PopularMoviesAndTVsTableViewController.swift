//
//  PopularMoviesAndTVsTableViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 18.07.21.
//

import UIKit

class PopularMoviesAndTVsTableViewController: UITableViewController {
    @IBOutlet var topView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var popularMovies: [MostPopularMovies] = [MostPopularMovies]()
    var movieId: String = ""
    var popularTVs: [MostPopularTVs] = [MostPopularTVs]()
    var rating: String = ""

    private enum Constants {
        static let popularMovieCellIdentifier = "popularMovieCellIdentifier"
        static let segueIdentifier = "toPresentPopularSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.applyGradientsOnNavigationBar()
        setupView()
        loadData()
    }

    private func setupView() {
        tableView.tableHeaderView = topView
    }

    private func loadData() {
        self.popularMovies = [MostPopularMovies](LocalDataManager.realm.objects(MostPopularMovies.self))
        self.popularTVs = [MostPopularTVs](LocalDataManager.realm.objects(MostPopularTVs.self))
        self.tableView.reloadData()
    }

    @IBAction func didTapSegmentedControl(_ sender: Any) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return popularMovies.count
        case 1:
            return popularTVs.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            guard let popularCell = tableView.dequeueReusableCell(withIdentifier: Constants.popularMovieCellIdentifier) as? TopMovieTableViewCell else { return UITableViewCell()
            }
            let popularMovie = popularMovies[indexPath.row]
            popularCell.rankLabel.text = popularMovie.rank
            let imageURL = URL(string: popularMovie.image)
            popularCell.imageImageView.kf.setImage(with: imageURL)
            popularCell.titleLabel.text = popularMovie.title
            popularCell.ratingAndYearLabel.text = "Year: \(popularMovie.year), imdbRating: \(popularMovie.imDbRating)"
            return popularCell
        case 1:
            guard let popularCell = tableView.dequeueReusableCell(withIdentifier: Constants.popularMovieCellIdentifier) as? TopMovieTableViewCell else { return UITableViewCell()
            }
            let popularTV = popularTVs[indexPath.row]
            popularCell.rankLabel.text = popularTV.rank
            let imageURL = URL(string: popularTV.image)
            popularCell.imageImageView.kf.setImage(with: imageURL)
            popularCell.titleLabel.text = popularTV.title
            popularCell.ratingAndYearLabel.text = "Year: \(popularTV.year), imdbRating: \(popularTV.imDbRating)"
            return popularCell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showHUD(progressLabel: "Loading Data")
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.movieId = popularMovies[indexPath.row].id
            self.rating = popularMovies[indexPath.row].imDbRating
        case 1:
            self.movieId = popularTVs[indexPath.row].id
            self.rating = popularTVs[indexPath.row].imDbRating
        default:
            return
        }
        guard let _ = LocalDataManager.realm.objects(Trailer.self).filter("imDbId == %@",self.movieId).first else {
            RequestManager.fetchTrailerForMovie(with: self.movieId) { _ in
                self.dismissHUD(isAnimated: true)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.segueIdentifier, sender: nil)
                }
            }
            return
        }
        self.dismissHUD(isAnimated: true)
        self.performSegue(withIdentifier: Constants.segueIdentifier, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destiantion = segue.destination as? PresentTopMovieTrailerViewController else {
            return
        }
        destiantion.movieId = movieId
        destiantion.rating = rating
    }
}
