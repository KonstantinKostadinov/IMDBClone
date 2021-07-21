//
//  SearchViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 18.07.21.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)
    let saveSearchQueue = DispatchQueue(label: "Save search queue", qos: .userInteractive)

    var searchTitles = [SearchedTitles]()
    var resultId = ""
    
    private enum Constants {
        static let cellIdentifier = "searchCellidentifier"
        static let segueIdentifier = "toShowResultSegue"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchController.searchResultsUpdater = self
        self.navigationController?.navigationBar.applyGradientsOnNavigationBar()

        self.navigationItem.hidesSearchBarWhenScrolling = false
        tableView.tableFooterView = UIView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        setupSearchBar()
    }

    private func setupSearchBar() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationController?.definesPresentationContext = true

        self.searchController.searchBar.placeholder = "Search by keyword"

        self.navigationItem.searchController = self.searchController

        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.barTintColor = UIColor.black
        self.searchController.searchBar.backgroundColor = .red
        self.searchController.searchBar.backgroundImage = self.navigationController?.navigationBar.backgroundImage(for: .default)

        if #available(iOS 13.0, *) {
            setSearchFieldBackgroundColor(UIColor.white)
            self.searchController.searchBar.searchTextField.textColor = UIColor.black
            self.searchController.searchBar.searchTextField.tokenBackgroundColor = UIColor.black
            self.searchController.searchBar.searchTextField.tintColor = UIColor.black
            self.searchController.searchBar.searchTextField.leftView?.tintColor = UIColor.black
        }
    }
    
    private func loadData() {
        searchTitles = [SearchedTitles](LocalDataManager.realm.objects(SearchedTitles.self))
        self.tableView.reloadData()
    }

    private func setSearchFieldBackgroundColor(_ color: UIColor) {
        searchController.searchBar.backgroundColor = color
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
      // Make up the default cornerRadius changed by `setSearchFieldBackgroundImage(_:for:)`
        searchController.searchBar.layer.cornerRadius = 10
        searchController.searchBar.clipsToBounds = true
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destiantion = segue.destination as? PresentTopMovieTrailerViewController else {
            return
        }
        destiantion.movieId = resultId
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText.isEmpty {
            self.loadData()
            return
        }

        RequestManager.fetchSearchResults(with: searchText) { (searchResultsArray, error) in
            guard error == nil, let searchResults = searchResultsArray else {
                return
            }

            self.searchTitles = searchResults
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let title = searchTitles[indexPath.row]
        cell.titleLabel.text = title.title
        cell.ratingLabel.isHidden = true
        cell.yearLabel.isHidden = true
        let imageURL = URL(string: title.image)
        cell.movieImageView.kf.setImage(with: imageURL)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showHUD(progressLabel: "Loading Data")
        self.resultId = searchTitles[indexPath.row].id
        let localSearch = LocalDataManager.realm.objects(SearchedTitles.self).filter("id == %@",self.searchTitles[indexPath.row].id).first
        if let _ = localSearch {
            //MARK: Improve logic
            self.dismissHUD(isAnimated: true)
            self.performSegue(withIdentifier: Constants.segueIdentifier, sender: nil)
            return
        } else {
            LocalDataManager.addData(searchTitles[indexPath.row], update: true)
        }
        
        guard let _ = LocalDataManager.realm.objects(Trailer.self).filter("imDbId == %@",self.resultId).first else {
            RequestManager.fetchTrailerForMovie(with: self.resultId) { _ in
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }

}
