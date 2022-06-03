//
//  EpisodesViewModel.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

final class EpisodesViewModel {
    
    let character: Character
    
    var title: String {
        return character.name
    }
    
    init(character: Character) {
        self.character = character
    }
}
