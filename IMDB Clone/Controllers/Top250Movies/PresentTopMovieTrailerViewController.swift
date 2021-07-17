//
//  PresentTopMovieTrailerViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import UIKit

class PresentTopMovieTrailerViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var movieId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "\(LocalDataManager.realm.object(ofType: Trailer.self, forPrimaryKey: movieId))"
        // Do any additional setup after loading the view.
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
