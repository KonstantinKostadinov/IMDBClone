//
//  SyncManager.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import Foundation
import UIKit
import RealmSwift

class SyncManager {
    static let dataQueue = DispatchQueue(label: "Data queue", qos: .default)
    static let syncQueue = DispatchQueue(label: "Sync Schedule Queue", qos: .background)

    class func fetchTopMovies(completion: ((_ successful: Bool) -> Void)?) {
        RequestManager.fetchTopMovies { (moviesArray, error) in
            guard error == nil, let fetchedMoviesArray = moviesArray else {
                completion?(false)
                return
            }

            dataQueue.async {
                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
                let avaiableTopMovies = realm.objects(TopMovies.self)
                var topMoviesToWrite = [TopMovies]()

                for aTopMovie in fetchedMoviesArray {
                    let localMovie = avaiableTopMovies.filter("id == %@",aTopMovie.id).first
                    if let _ = localMovie {
                        //MARK: Improve logic 
                    } else {
                        topMoviesToWrite.append(aTopMovie)
                    }

                }
                LocalDataManager.addData(topMoviesToWrite, update: true, realm: realm)
                DispatchQueue.main.async {
                    completion?(true)
                }
            }
        }
    }
}
