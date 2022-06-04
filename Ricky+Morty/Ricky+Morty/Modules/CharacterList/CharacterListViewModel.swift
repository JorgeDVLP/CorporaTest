//
//  CharacterListViewModel.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

fileprivate enum FilterType: String {
    case all
    case alive
    case dead
    case unknown
}

final class CharacterListViewModel {
    
    private let characterService: CharacterService
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private var currentFilter: FilterType = .all
    private var characters: [Character] = []
    
    private var statusValue: String? {
        guard currentFilter != .all else {
            return nil
        }
        return currentFilter.rawValue
    }
    
    var onDataFetched: ((_ size: Int) -> Void)?
    
    var onDataAdded: (([IndexPath]) -> Void)?
    
    var onShouldDisplayIndicator: ((Bool) -> Void)?
    
    var onError: ((_ message: String) -> Void)?
    
    init(characterService: CharacterService = APIManager.shared) {
        self.characterService = characterService
    }
    
    private func fetchCharacters(completion: @escaping ([Character]) -> Void) {
        self.isFetching = true
        self.characterService.getCharacters(page: self.currentPage, status: self.statusValue) { [weak self] result in
            self?.isFetching = false
            
            switch result {
            case .failure(let error):
                completion([])
                print(error.localizedDescription)
                self?.showError(error.localizedDescription)
            case .success(let characters):
                completion(characters)
            }
        }
    }
    
    private func showIndicatorView(_ display: Bool = true) {
        DispatchQueue.main.async {
            self.onShouldDisplayIndicator?(display)
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            self.onError?(message)
        }
    }
    
    func fetchData() {
        self.currentPage = 1
        self.showIndicatorView()
        fetchCharacters { [weak self] items in
            guard let self = self else { return }
            self.showIndicatorView(false)
            DispatchQueue.main.async {
                self.characters = items.sorted(by: { $0.id < $1.id })
                self.onDataFetched?(items.count)
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
    
    func onFilterChanged(index: Int) {
        switch index {
        case 1:
            currentFilter = .alive
        case 2:
            currentFilter = .dead
        case 3:
            currentFilter = .unknown
        default:
            currentFilter = .all
        }
        fetchData()
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
            }
        }
    }
}
