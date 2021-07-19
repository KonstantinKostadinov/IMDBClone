//
//  SearchedTitles.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 19.07.21.
//

import Foundation
import RealmSwift

class SearchedTitles: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var resultType: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var title: String = ""
    
    static override func primaryKey() -> String? {
        return "id"
    }
}
