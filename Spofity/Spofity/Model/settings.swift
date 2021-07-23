//
//  settings.swift
//  Spofity
//
//  Created by Pallavi on 23/07/21.
//

import Foundation
struct Section {
    let title:String
    let options: [Option]
}
struct Option {
    let title:String
    let handler: () -> Void
}
