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
    private var isFetching: Bool = false
    private var initialFetch: Bool = true
    
    private var characters: [Character] = []
    
    var onDataFetched: (() -> Void)?
    
    var onDataAdded: (([IndexPath]) -> Void)?
    
    init(characterService: CharacterService = APIManager.shared) {
        self.characterService = characterService
    }
    
    func fetchData() {
        self.currentPage = 1
        fetchCharacters { [weak self] items in
            guard let self = self else { return }
            
            print("Items fetched \(items.count) for page \(self.currentPage)", "Total", self.characters.count)
            DispatchQueue.main.async {
                self.characters = items.sorted(by: { $0.id < $1.id })
                self.onDataFetched?()
            }
        }
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
    
    private func fetchCharacters(completion: @escaping ([Character]) -> Void) {
        self.isFetching = true
        print("Fetching characters from page", currentPage)
        self.characterService.getCharacters(page: currentPage) { [weak self] result in
            self?.isFetching = false
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let characters):
                completion(characters)
            }
        }
    }
    
    func fetchNextPage() {
        guard self.isFetching == false else { return }
        self.currentPage += 1
        fetchCharacters { [weak self] items in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.characters.append(contentsOf: items.sorted(by: { $0.id < $1.id }))
                var newRows: [IndexPath] = []
                for i in 0..<items.count {
                    let count = self.characters.count - 1
                    newRows.append(IndexPath(row: count - i, section: 0))
                }
                self.onDataAdded?(newRows)
                print("New items fetched \(items.count) for page \(self.currentPage)", "Total", self.characters.count)
            }
        }
    }
}
