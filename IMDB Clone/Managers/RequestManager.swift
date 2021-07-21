//
//  RequestManager.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import Foundation
import Alamofire

enum IMDBError: Error {
    case cannotParseJSON
}

public class API: URLConvertible {
    let stringCall: String

    var baseURL: String {
        return "https://imdb-api.com/API/"
    }

    public init(_ value: String) {
        assert(value.first != "/", "url paths should not start with \'/\'")
        self.stringCall = value
    }

    public func asURL() throws -> URL {
        return URL(string: baseURL + self.stringCall)!
    }
}

extension API {
    static let topMovies = API("Top250Movies/k_2y9cl6jb")
    static let topTVs = API("Top250TVs/k_2y9cl6jb")
    static let popularMovies = API("MostPopularMovies/k_2y9cl6jb")
    static let popularTVs = API("MostPopularTVs/k_2y9cl6jb")
}

extension API {
    class func trilerForMovie(with id: String) -> API {
        API("Trailer/k_2y9cl6jb/\(id)")
    }

    class func search(by keyword: String) -> API {
        API("SearchTitle/k_2y9cl6jb/\(keyword)")
    }

    class func movieTrailer(with id: String) -> API {
        API("YouTubeTrailer/k_2y9cl6jb/\(id)")
    }

    class func fullCast(from id: String) -> API {
        API("FullCast/k_2y9cl6jb/\(id)")
    }
}

class RequestManager: NSObject {
    static let standard = RequestManager()
    static let updateDataQueue = DispatchQueue(label: "Update data queue", qos: .userInteractive)


    class func fetchTopMovies(completion: ((_ dict: [TopMovies]?, _ error: Error?) -> Void)? = nil) {
        Alamofire.request(API.topMovies, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            guard response.error == nil else {
                completion?(nil, response.error)
                return
            }

            guard response.result.error == nil else {
                completion?(nil, response.result.error)
                return
            }

            guard let dict = response.result.value as? [String:Any],
                  let movieItems = dict["items"] as? Array<[String:Any]> else {
                completion?(nil, IMDBError.cannotParseJSON)
                return
            }
            let movies = movieItems.compactMap({TopMovies(value: $0)})
            completion?(movies, nil)
        }
    }

    class func fetchTopTVs(completion: ((_ dict: [TopTVs]?, _ error: Error?) -> Void)? = nil) {
        Alamofire.request(API.topTVs, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            guard response.error == nil else {
                completion?(nil, response.error)
                return
            }

            guard response.result.error == nil else {
                completion?(nil, response.result.error)
                return
            }

            guard let dict = response.result.value as? [String:Any],
                  let tvItems = dict["items"] as? Array<[String:Any]> else {
                completion?(nil, IMDBError.cannotParseJSON)
                return
            }
            let tvs = tvItems.compactMap({TopTVs(value: $0)})
            completion?(tvs, nil)
        }
    }

    class func fetchTrailerForMovie(with id: String, completion: ((_ error: Error?) -> Void)? = nil) {
        Alamofire.request(API.trilerForMovie(with: id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            updateDataQueue.async {
                guard response.error == nil else {
                    completion?(response.error)
                    return
                }

                guard response.result.error == nil else {
                    completion?(response.result.error)
                    return
                }

                guard let dict = response.result.value as? [String:String] else {
                    completion?(IMDBError.cannotParseJSON)
                    return
                }


                let trailer = Trailer(json: dict)
                let realm = LocalDataManager.backgroundRealm(queue: updateDataQueue)
                LocalDataManager.addData(trailer, update: true, realm: realm)
                completion?(nil)
            }
        }
    }

    class func fetchMostPopularMovies( completion: ((_ movies: [MostPopularMovies]?,_ error: Error?) -> Void)? = nil) {
        Alamofire.request(API.popularMovies, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            guard response.error == nil else {
                completion?(nil, response.error)
                return
            }

            guard response.result.error == nil else {
                completion?(nil, response.result.error)
                return
            }

            guard let dict = response.result.value as? [String:Any],
                  let movieItems = dict["items"] as? Array<[String:Any]> else {
                completion?(nil, IMDBError.cannotParseJSON)
                return
            }
            let popularMovies = movieItems.compactMap({MostPopularMovies(value: $0)})
            completion?(popularMovies, nil)
        }
    }

    class func fetchMostPopularTVs( completion: ((_ movies: [MostPopularTVs]?,_ error: Error?) -> Void)? = nil) {
        Alamofire.request(API.popularTVs, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            guard response.error == nil else {
                completion?(nil, response.error)
                return
            }

            guard response.result.error == nil else {
                completion?(nil, response.result.error)
                return
            }

            guard let dict = response.result.value as? [String:Any],
                  let movieItems = dict["items"] as? Array<[String:Any]> else {
                completion?(nil, IMDBError.cannotParseJSON)
                return
            }
            let popularTVs = movieItems.compactMap({MostPopularTVs(value: $0)})
            completion?(popularTVs, nil)
        }
    }

    class func fetchSearchResults(with keyword: String, completion: ((_ searchResults: [SearchedTitles]?,_ error: Error?)-> Void)? = nil) {
        Alamofire.request(API.search(by: keyword), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            guard response.error == nil else {
                completion?(nil, response.error)
                return
            }

            guard response.result.error == nil else {
                completion?(nil, response.result.error)
                return
            }

            guard let dict = response.result.value as? [String:Any],
                  let searchResults = dict["results"] as? Array<[String:Any]> else {
                completion?(nil, IMDBError.cannotParseJSON)
                return
            }

            let searchResultsArray = searchResults.compactMap({SearchedTitles(value: $0)})
            completion?(searchResultsArray, nil)
        }
    }

    class func fetchMovieTrailer(with id: String, completion: ((_ movieTrailer: MovieTrailer?, _ error: Error?)-> Void)? = nil) {
        Alamofire.request(API.movieTrailer(with: id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            updateDataQueue.async {
                guard response.error == nil else {
                    completion?(nil, response.error)
                    return
                }

                guard response.result.error == nil else {
                    completion?(nil, response.result.error)
                    return
                }

                guard let dict = response.result.value as? [String:String] else {
                    completion?(nil, IMDBError.cannotParseJSON)
                    return
                }

                let trailer = MovieTrailer(json: dict)
                let realm = LocalDataManager.backgroundRealm(queue: updateDataQueue)
                LocalDataManager.addData(trailer, update: true, realm: realm)
                completion?(trailer, nil)
            }
        }
    }

    class func fetchCast(with id: String, completion: ((_ dicrectors: Array<[String:Any]>?, _ actors: Array<[String:Any]>?, _ error: Error?)->Void)? = nil) {
        Alamofire.request(API.fullCast(from: id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in

            guard response.error == nil else {
                completion?(nil, nil, response.error)
                return
            }

            guard response.result.error == nil else {
                completion?(nil, nil, response.result.error)
                return
            }
            
            guard let response = response.result.value as? [String: Any],
                  let directorsDict = response["directors"] as? [String: Any],
                  let directors = directorsDict["items"] as? Array<[String:Any]>,
                  let actorsDict = response["actors"] as? Array<[String:Any]> else {
                completion?(nil,nil, IMDBError.cannotParseJSON)
                return
            }
            completion?(directors, actorsDict, nil)
        }
    }
}
