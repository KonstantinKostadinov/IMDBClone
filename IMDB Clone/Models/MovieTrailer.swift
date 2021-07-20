//
//  MovieTrailer.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 20.07.21.
//

import Foundation
import RealmSwift

class MovieTrailer: Object {
    @objc dynamic var imDbId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var fullTitle: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var videoId: String = ""
    @objc dynamic var videoUrl: String = ""

    static override func primaryKey() -> String? {
        return "imDbId"
    }

    convenience init(json: [String: String]) {
        self.init()
        self.imDbId = json["imDbId"] ?? ""
        self.title = json["title"] ?? ""
        self.fullTitle = json["fullTitle"] ?? ""
        self.type = json["type"] ?? ""
        self.year = json["year"] ?? ""
        self.videoId = json["videoId"] ?? ""
        self.videoUrl = json["videoUrl"] ?? ""
    }
}
