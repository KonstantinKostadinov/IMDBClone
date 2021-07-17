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
        #if TEST
        return "https://imdb-api.com/API/"
        #elseif STAGING
        return "https://imdb-api.com/API/"
        #else
        return "https://imdb-api.com/API/"
        #endif
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
}


class RequestManager: NSObject {
    static let standard = RequestManager()

    class func fetchTopMovies(completion: ((_ dict: [String: Any?]?, _ error: Error?) -> Void)? = nil) {
        Alamofire.request(API.topMovies, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            guard response.error == nil else {
                completion?(nil, response.error)
                return
            }

            guard response.result.error == nil else {
                completion?(nil, response.result.error)
                return
            }

            guard let dict = response.result.value as? [String:Any] else {
                completion?(nil, IMDBError.cannotParseJSON)
                return
            }
            completion?(dict, nil)
        }
    }
}
