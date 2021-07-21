//
//  SearchVideoLicense.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

public enum SearchVideoLicense: String {
    
    /// Return all videos, regardless of which license they have, that match the query parameters.
    case any
    
    /// Only return videos that have a Creative Commons license. Users can reuse videos with this license in other videos that they create.
    /// For more information: https://support.google.com/youtube/answer/2797468
    case creativeCommon
    
    /// Only return videos that have the standard YouTube license.
    case youtube
}
