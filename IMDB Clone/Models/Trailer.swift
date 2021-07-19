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

    convenience init(json: [String:Any]) {
        self.init()
        self.imDbId = json["imDbId"] as? String ?? ""
        self.title = json["title"] as? String ?? ""
        self.fullTitle = json["fullTitle"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        self.year = json["year"] as? String ?? ""
        self.videoId = json["videoId"] as? String ?? ""
        self.videoTitle = json["videoTitle"] as? String ?? ""
        self.videoDescription = json["videoDescription"] as? String ?? ""
        self.thumbnailUrl = json["thumbnailUrl"] as? String ?? ""
        self.updateDate = json["updateDate"] as? String ?? ""
        self.link = json["link"] as? String ?? ""
        self.linkEmbed = json["linkEmbed"] as? String ?? ""
    }
}
