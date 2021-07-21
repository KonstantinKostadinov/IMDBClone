//
//  PresentTopMovieTrailerViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import UIKit
import YoutubeKit
import Kingfisher

class PresentTopMovieTrailerViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var thumbmnailImageView: UIImageView!

    var trailer = Trailer()
    var movieTrailer = MovieTrailer()
    var movieId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        fetchTrailerData()
        // Do any additional setup after loading the view.
    }

    private func loadData() {
        textView.text = "\(LocalDataManager.realm.object(ofType: Trailer.self, forPrimaryKey: movieId))"
        trailer = LocalDataManager.realm.object(ofType: Trailer.self, forPrimaryKey: movieId) ?? Trailer()
        let imageURL = URL(string: self.trailer.thumbnailUrl)
        thumbmnailImageView.kf.setImage(with: imageURL)
    }

    private func fetchTrailerData() {
        RequestManager.fetchMovieTrailer(with: trailer.imDbId) { (movieTrailer, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showHUD(progressLabel: error.localizedDescription)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismissHUD(isAnimated: true)
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
        }
    }
    @IBAction func didTapThumbnailImage(_ sender: Any) {
        guard let movieTrailer = LocalDataManager.realm.object(ofType: MovieTrailer.self, forPrimaryKey: self.trailer.imDbId) else { return }
        if let url = URL(string: movieTrailer.videoUrl) {
            UIApplication.shared.open(url)
        }
    }
}
