//
//  UserProfile.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import Foundation
struct UserProfile:Codable {
    let country : String
    let display_name: String
    let email : String
    let explicit_content : [String:Bool]
    let external_urls : [String:String]
    //let followers : [String:Codable?]
    let href:String
    let id : String
    let images : [APIImage]
    let product : String
  
}


   
