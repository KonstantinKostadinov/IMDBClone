//
//  MostPopularTVs.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 18.07.21.
//

import Foundation
import RealmSwift

class MostPopularTVs: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var fullTitle: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var imDbRating: String = ""
    @objc dynamic var crew: String = ""
    @objc dynamic var imDbRatingCount: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var rank: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var rankUpDown: String = ""
    
    static override func primaryKey() -> String? {
        return "id"
    }
}
