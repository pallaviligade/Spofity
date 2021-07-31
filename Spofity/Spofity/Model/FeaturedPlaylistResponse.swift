//
//  FeaturedPlaylistResponse.swift
//  Spofity
//
//  Created by Pallavi on 29/07/21.
//

import Foundation
struct FeaturedPlaylistResponse:Codable {
    let playlists: playlistsResponse
}
struct playlistsResponse:Codable {
    let items:[Playlist]
}

struct User:Codable {
    let display_name:String
    let external_urls: [String:String]
    let href: String
    let  id :String
}



