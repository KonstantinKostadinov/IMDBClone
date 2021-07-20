//
//  Trailer.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import Foundation
import RealmSwift

class Trailer: Object {
    @objc dynamic var imDbId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var fullTitle: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var videoId: String = ""
    @objc dynamic var videoTitle: String = ""
    @objc dynamic var videoDescription: String = ""
    @objc dynamic var thumbnailUrl: String = ""
    @objc dynamic var updateDate: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var linkEmbed: String = ""
    
    static override func primaryKey() -> String? {
        return "imDbId"
    }

    convenience init(json: [String:String]) {
        self.init()
        self.imDbId = json["imDbId"] ?? ""
        self.title = json["title"] ?? ""
        self.fullTitle = json["fullTitle"] ?? ""
        self.type = json["type"] ?? ""
        self.year = json["year"] ?? ""
        self.videoId = json["videoId"] ?? ""
        self.videoTitle = json["videoTitle"] ?? ""
        self.videoDescription = json["videoDescription"] ?? ""
        self.thumbnailUrl = json["thumbnailUrl"] ?? ""
        self.updateDate = json["updateDate"] ?? ""
        self.link = json["link"] ?? ""
        self.linkEmbed = json["linkEmbed"] ?? ""
    }
}
