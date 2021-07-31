//
//  Artist.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import Foundation
struct Artist:Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String:String]
}
