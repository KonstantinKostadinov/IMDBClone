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
        SyncManager.fetchTopMovies { _ in
            self.dismissHUD(isAnimated: true)
            self.performSegue(withIdentifier: Constants.segue, sender: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
