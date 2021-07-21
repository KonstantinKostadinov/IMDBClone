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
    @IBOutlet weak var thumbmnailImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var trailer = Trailer()
    var movieTrailer = MovieTrailer()
    var movieId: String = ""
    var rating: String = ""

    var actors = Array<[String:Any]>()
    var directors = Array<[String:Any]>()
    private enum Constants {
        static let actorCellIdentifier = "actorCellIdentifier"
        static let normalCollectionCellIdentifier = "normalCollectionCellIdentifier"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupViews()
        fetchTrailerData()
        fetchCastData()
        // Do any additional setup after loading the view.
    }

    private func loadData() {
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

    private func fetchCastData() {
        RequestManager.fetchCast(with: trailer.imDbId) { (directors, actors, error) in
            if let _ = error {
                return
            }

            guard let directorsArray = directors, let actorsArray = actors else { return }
            print(actors)
            print(directors)
            
            self.actors = actorsArray
            self.directors = directorsArray
            self.collectionView.reloadData()
        }
    }

    private func setupViews() {
        titleLabel.text = trailer.title
        yearLabel.text = "Year: \(trailer.year)"
        ratingLabel.text = "Rating: \(rating)"
        descriptionLabel.text = " Description: \(trailer.videoDescription)"
        collectionView.delegate = self
        collectionView.dataSource = self
        thumbmnailImageView.addOverlay()
//        var layout = UICollectionViewFlowLayout()
//        collectionView.collectionViewLayout = UICollectionViewLayout()
        
    }
    @IBAction func didTapThumbnailImage(_ sender: Any) {
        guard let movieTrailer = LocalDataManager.realm.object(ofType: MovieTrailer.self, forPrimaryKey: self.trailer.imDbId) else { return }
        if let url = URL(string: movieTrailer.videoUrl) {
            UIApplication.shared.open(url)
        }
    }
}

extension PresentTopMovieTrailerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if actors.isEmpty {
            return 1
        } else {
            return actors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if actors.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.normalCollectionCellIdentifier, for: indexPath)
            cell.backgroundColor = .lightGray
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.actorCellIdentifier, for: indexPath) as? ActorCollectionViewCell else {
                return UICollectionViewCell()
            }
            let actor = actors[indexPath.item]
            cell.actorsNameLabel.text = actor["name"] as? String ?? ""
            let imageURL = URL(string: actor["image"] as? String ?? "")
            cell.actorImageView.kf.setImage(with: imageURL)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155, height: 174)
    }
    
}
