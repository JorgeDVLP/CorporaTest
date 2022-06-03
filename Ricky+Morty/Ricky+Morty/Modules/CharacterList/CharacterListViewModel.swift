//
//  CharacterListViewModel.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

final class CharacterListViewModel {
    
    private let characterService: CharacterService
    private var currentPage: Int = 1
    private var characters: [Character] = []
    
    var onDataFetched: (() -> Void)?
    
    init(characterService: CharacterService = APIManager.shared) {
        self.characterService = characterService
    }
    
    func fetchData() {
        self.currentPage = 1
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        self.characterService.getCharacters(page: currentPage) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let characters):
                self?.characters = characters.sorted(by: { $0.id < $1.id })
                DispatchQueue.main.async {
                    self?.onDataFetched?()
                }
            }
        }
    }
    
    func onScrolled(to: IndexPath) {
        
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(forSection section: Int) -> Int {
        return self.characters.count
    }
    
    func getItem(forIndex index: IndexPath) -> Character {
        return self.characters[index.row]
    }
}
