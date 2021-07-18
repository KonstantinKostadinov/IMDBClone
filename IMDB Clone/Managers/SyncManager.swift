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

    class func syncTopTVsAndMovies(completion: ((_ success: Bool) -> Void)? = nil) {

        let syncGroup = DispatchGroup()

        syncQueue.async {
            print("🔄 Data sync started \(Date())")
            syncGroup.enter()
            SyncManager.fetchTopMovies { (_) in
                syncGroup.leave()
            }

            syncGroup.wait()
            syncGroup.enter()

            SyncManager.fetchTopTVs { (_) in
                syncGroup.leave()
            }

            syncGroup.wait()
            syncGroup.enter()

            SyncManager.fetchPopularMovies { (_) in
                syncGroup.leave()
            }

            syncGroup.wait()
            syncGroup.enter()

            SyncManager.fetchPopularTVs { (_) in
                syncGroup.leave()
            }

            syncGroup.wait()

            DispatchQueue.main.async {
                print("🔄 Data sync completed \(Date())")
                completion?(true)
            }
        }
    }

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
                        DispatchQueue.main.async {
                            completion?(true)
                        }
                        return
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
    
    class  func fetchTopTVs(completion: ((_ successful:Bool) -> Void)?) {
        RequestManager.fetchTopTVs { (tvsArray, error) in
            guard error == nil, let fetchedTvsArray = tvsArray else {
                completion?(false)
                return
            }

            dataQueue.async {
                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
                let avaiableTopMovies = realm.objects(TopTVs.self)
                var topTvToWrite = [TopTVs]()

                for aTopTv in fetchedTvsArray {
                    let localMovie = avaiableTopMovies.filter("id == %@",aTopTv.id).first
                    if let _ = localMovie {
                        //MARK: Improve logic
                        DispatchQueue.main.async {
                            completion?(true)
                        }
                        return
                    } else {
                        topTvToWrite.append(aTopTv)
                    }

                }
                LocalDataManager.addData(topTvToWrite, update: true, realm: realm)
                DispatchQueue.main.async {
                    completion?(true)
                }
            }
        }
    }
    
    class func fetchPopularMovies(completion: ((_ successful: Bool) -> Void)?) {
        RequestManager.fetchMostPopularMovies { (popularMoviesArray, error) in
            guard error == nil, let fetchedMoviesArray = popularMoviesArray else {
                completion?(false)
                return
            }

            dataQueue.async {
                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
                let avaiableTopMovies = realm.objects(MostPopularMovies.self)
                var topMoviesToWrite = [MostPopularMovies]()

                for aPopularMovie in fetchedMoviesArray {
                    let localMovie = avaiableTopMovies.filter("id == %@",aPopularMovie.id).first
                    if let _ = localMovie {
                        //MARK: Improve logic
                        DispatchQueue.main.async {
                            completion?(true)
                        }
                        return
                    } else {
                        topMoviesToWrite.append(aPopularMovie)
                    }

                }
                LocalDataManager.addData(topMoviesToWrite, update: true, realm: realm)
                DispatchQueue.main.async {
                    completion?(true)
                }
            }
        }
    }
    
    class func fetchPopularTVs(completion: ((_ successful: Bool) -> Void)?) {
        RequestManager.fetchMostPopularTVs { (tvsArray, error) in
            guard error == nil, let fetchedTVsArray = tvsArray else {
                completion?(false)
                return
            }

            dataQueue.async {
                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
                let avaiableTopMovies = realm.objects(MostPopularTVs.self)
                var topMoviesToWrite = [MostPopularTVs]()

                for aPopularTV in fetchedTVsArray {
                    let localMovie = avaiableTopMovies.filter("id == %@",aPopularTV.id).first
                    if let _ = localMovie {
                        //MARK: Improve logic
                        DispatchQueue.main.async {
                            completion?(true)
                        }
                        return
                    } else {
                        topMoviesToWrite.append(aPopularTV)
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
