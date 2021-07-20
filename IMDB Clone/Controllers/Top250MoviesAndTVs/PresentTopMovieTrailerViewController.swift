//
//  PresentTopMovieTrailerViewController.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import UIKit
import AVFoundation
import AVKit

class PresentTopMovieTrailerViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var videoPlayerView: UIView!

    var trailer = Trailer()
    var movieTrailer = MovieTrailer()
    var movieId: String = ""
    var player: AVPlayer!
    var avpController = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        fetchTrailerData()
        // Do any additional setup after loading the view.
    }

    private func loadData() {
        textView.text = "\(LocalDataManager.realm.object(ofType: Trailer.self, forPrimaryKey: movieId))"
        trailer = LocalDataManager.realm.object(ofType: Trailer.self, forPrimaryKey: movieId) ?? Trailer()
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

            DispatchQueue.main.sync {
                let movieTrailer = LocalDataManager.realm.object(ofType: MovieTrailer.self, forPrimaryKey: self.trailer.imDbId)
                if let unwrappedTrailer = movieTrailer {
                    self.movieTrailer = unwrappedTrailer
                    self.setupPlayer()
                } else {
                    self.showHUD(progressLabel: "Could not present Trailer")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.dismissHUD(isAnimated: true)
                    }
                }
            }
        }
    }
    // swiftlint:disable all
    private func setupPlayer() {
        if let url = URL(string: movieTrailer.videoUrl) {
            self.player = AVPlayer(url: url)
            self.avpController = AVPlayerViewController()
            self.avpController.player = self.player
            avpController.view.frame = videoPlayerView.frame
            self.addChild(avpController)
            self.view.addSubview(avpController.view)
        }
    }
    // swiftlint:enable all

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
