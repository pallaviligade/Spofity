//
//  NewRealseResponse.swift
//  Spofity
//
//  Created by Pallavi on 28/07/21.
//

import Foundation
struct NewRealseResponse:Codable {
    let albums: AlbumResponse
}

struct AlbumResponse:Codable {
    let items:[Album]
}

struct Album:Codable {
    let album_type:String
    let artists:[Artist]
    let available_markets:[String]
    let id:String
    let images : [APIImage]

    let name: String
    let release_date:String
    let total_tracks:Int
}

