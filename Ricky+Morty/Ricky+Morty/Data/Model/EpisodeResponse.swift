//
//  EpisodeResponse.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 4/6/22.
//

import Foundation

struct EpisodeResponse: Decodable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
}

extension EpisodeResponse {
    func toEpisode() -> Episode {
        let episode = Episode(id: id, name: name, date: air_date, episode: episode)
        return episode
    }
}
