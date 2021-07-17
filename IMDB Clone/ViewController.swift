//
//  ViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var moviesDict: [TopMovies] = [TopMovies]()
    private enum Constants {
        static let titleName = "Top 250 Movies"
        static let topMovieCellIdentifier = "topMovieCellIdentifier"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        RequestManager.fetchTopMovies { (moviesArray, error) in
            if let error = error {
                print("error: ", error.localizedDescription)
                return
            }
            guard let movies = moviesArray else { return }
            self.moviesDict = movies
            self.tableView.reloadData()
        }
    }

    private func setupViews() {
        self.navigationController?.title = Constants.titleName
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDict.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let topMovieCell = tableView.dequeueReusableCell(withIdentifier: Constants.topMovieCellIdentifier) as? TopMovieTableViewCell else {
            return UITableViewCell()
        }

        let movie = moviesDict[indexPath.row]
        let imageURL = URL(string: movie.image)
        topMovieCell.imageImageView.kf.setImage(with: imageURL)
        topMovieCell.titleLabel.text = movie.title
        topMovieCell.ratingAndYearLabel.text = "Year: \(movie.year), imdbRating: \(movie.imDbRating)"
        return topMovieCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
