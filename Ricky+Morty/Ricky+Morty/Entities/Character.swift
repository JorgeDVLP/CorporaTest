//
//  Character.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

enum CharacterStatus {
    case alive
    case dead
    case unknown
}

// una imagen circular del personaje, su nombre, su planeta de origen y su status actual (vivo, muerto o desconocido).
struct Character {
    let id: Int
    let name: String
    let origin: String
    let status: CharacterStatus
    let imageURL: String
}
