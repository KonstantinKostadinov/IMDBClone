//
//  LoadingViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import UIKit

class LoadingViewController: UIViewController {

    private enum Constants {
        static let segue = "presentTabBarSegue"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showHUD(progressLabel: "Loading data")
        fetchMovies()
    }
    
    private func fetchMovies() {
        SyncManager.syncTopTVsAndMovies {_ in
            self.dismissHUD(isAnimated: true)
            self.performSegue(withIdentifier: Constants.segue, sender: nil)
        }
    }
}
