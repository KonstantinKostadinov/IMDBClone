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
        self.navigationController?.navigationBar.applyHorizontalGradientForPatientDetails()
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
