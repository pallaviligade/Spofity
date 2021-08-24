//
//  AlbumDetailsResponse.swift
//  Spofity
//
//  Created by Pallavi on 05/08/21.
//

import Foundation
struct AlbumDetailsResponse:Codable {
    let album_type:String
    let  artists :[Artist]
    let available_markets:[String]
    let external_urls:[String:String]
    let id:String
    let image:[APIImage]?
    let label:String
    let name:String
    let tracks:TrackResponse
    
}
struct TrackResponse:Codable {
    let items:[AudioTrack]
}
