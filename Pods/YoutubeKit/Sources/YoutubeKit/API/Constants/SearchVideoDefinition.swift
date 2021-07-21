//
//  SearchVideoDefinition.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//


public enum SearchVideoDefinition: String {
    
    /// Return all videos, regardless of their resolution.
    case any
    
    /// Only retrieve HD videos.
    case high
    
    /// Only retrieve videos in standard definition.
    case standard
}
