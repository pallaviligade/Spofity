//
//  PlaylistdetailsResponse.swift
//  Spofity
//
//  Created by Pallavi on 05/08/21.
//

import Foundation
struct PlaylistdetailsResponse:Codable {
 
    let description:String
    let external_urls : [String:String]
    let id:String
    let images:[APIImage]?
    let name:String
    let `public` : Bool
    let tracks:PlaylistTrackResponse
}
struct PlaylistTrackResponse:Codable {
    let items:[PlaylistItem]
}
struct PlaylistItem:Codable {
    let track:AudioTrack
}
