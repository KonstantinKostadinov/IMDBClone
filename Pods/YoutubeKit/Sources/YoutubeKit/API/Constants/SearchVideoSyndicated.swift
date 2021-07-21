//
//  SearchVideoSyndicated.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//


public enum SearchVideoSyndicated: String {
    
    /// Return all videos, syndicated or not.
    case any
    
    /// Only retrieve syndicated videos.
    case onlySyndicated = "true"
}
