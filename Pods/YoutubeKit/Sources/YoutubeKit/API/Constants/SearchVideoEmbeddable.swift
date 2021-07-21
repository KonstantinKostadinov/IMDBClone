//
//  SearchVideoEmbeddable.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

public enum SearchVideoEmbeddable: String {
    
    /// Return all videos, embeddable or not.
    case any
    
    /// Only retrieve embeddable videos.
    case onlyEmbeddable = "true"
}
