//
//  ViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var topMovies: [TopMovies] = [TopMovies]()
    var movieId: String = ""
    var topTvs: [TopTVs] = [TopTVs]()
    var movieRating: String = ""
    private enum Constants {
        static let titleName = "Top 250 Movies"
        static let topMovieCellIdentifier = "topMovieCellIdentifier"
        static let toPresentTopMovieSegue = "toPresentTopMovieSegue"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.applyGradientsOnNavigationBar()
        setupViews()
        loadData()
    }

    private func setupViews() {
        self.navigationController?.navigationItem.title = Constants.titleName
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func loadData() {
        self.topMovies = [TopMovies](LocalDataManager.realm.objects(TopMovies.self))
        self.topTvs = [TopTVs](LocalDataManager.realm.objects(TopTVs.self))
        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destiantion = segue.destination as? PresentTopMovieTrailerViewController else {
            return
        }
        destiantion.movieId = movieId
        destiantion.rating = movieRating
    }

    @IBAction func didTapSegmentedControl(_ sender: Any) {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return topMovies.count
        case 1:
            return topTvs.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            guard let topMovieCell = tableView.dequeueReusableCell(withIdentifier: Constants.topMovieCellIdentifier) as? TopMovieTableViewCell else {
                return UITableViewCell()
            }

            let movie = topMovies[indexPath.row]
            let imageURL = URL(string: movie.image)
            topMovieCell.imageImageView.kf.setImage(with: imageURL)
            topMovieCell.titleLabel.text = movie.title
            topMovieCell.ratingAndYearLabel.text = "Year: \(movie.year), imdbRating: \(movie.imDbRating)"
            topMovieCell.rankLabel.text = movie.rank
            return topMovieCell
        case 1:
            guard let topMovieCell = tableView.dequeueReusableCell(withIdentifier: Constants.topMovieCellIdentifier) as? TopMovieTableViewCell else {
                return UITableViewCell()
            }

            let topTv = topTvs[indexPath.row]
            let imageURL = URL(string: topTv.image)
            topMovieCell.imageImageView.kf.setImage(with: imageURL)
            topMovieCell.titleLabel.text = topTv.title
            topMovieCell.ratingAndYearLabel.text = "Year: \(topTv.year), imdbRating: \(topTv.imDbRating)"
            topMovieCell.rankLabel.text = topTv.rank
            return topMovieCell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showHUD(progressLabel: "Loading Data")
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.movieId = topMovies[indexPath.row].id
            self.movieRating = topMovies[indexPath.row].imDbRating
        case 1:
            self.movieId = topTvs[indexPath.row].id
            self.movieRating = topTvs[indexPath.row].imDbRating
        default:
            return
        }
        guard let _ = LocalDataManager.realm.objects(Trailer.self).filter("imDbId == %@",self.movieId).first else {
            RequestManager.fetchTrailerForMovie(with: self.movieId) { _ in
                self.dismissHUD(isAnimated: true)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.toPresentTopMovieSegue, sender: nil)
                }
            }
            return
        }
        self.dismissHUD(isAnimated: true)
        self.performSegue(withIdentifier: Constants.toPresentTopMovieSegue, sender: nil)
    }
}
