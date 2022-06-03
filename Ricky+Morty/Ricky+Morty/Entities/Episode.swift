//
//  Episode.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

struct Episode: Decodable {
    let id: Int
    let name: String
    let date: String
    let episode: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case date = "air_date"
        case episode = "episode"
    }
}
