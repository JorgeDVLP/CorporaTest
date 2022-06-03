//
//  CharacterResponse.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

struct GenericAPIResponse<T: Decodable>: Decodable {
    let results: [T]
}

struct CharacterResult: Decodable {
    let id: Int
    let name: String
    let status: String
    let origin: Origin
    let image: String
}

struct Origin: Decodable {
    let name: String
}

extension CharacterResult {
    //status: filter by the given status (alive, dead or unknown).
    func toCharacter() -> Character {
        var status: CharacterStatus = .unknown
        
        switch self.status {
        case "alive":
            status = CharacterStatus.alive
        case "dead":
            status = CharacterStatus.dead
        default:
            status = CharacterStatus.unknown
        }
        
        let ch = Character(id: self.id, name: self.name, origin: self.origin.name, status: status, imageURL: image)
        return ch
    }
}
