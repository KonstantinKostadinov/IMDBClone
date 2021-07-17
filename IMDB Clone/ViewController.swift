//
//  ViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RequestManager.fetchTopMovies { (moviesDict, error) in
            if let error = error {
                print("error: ", error.localizedDescription)
                return
            }
            print("MOvies Dictionary: ", moviesDict)
        }
    }

    
}

