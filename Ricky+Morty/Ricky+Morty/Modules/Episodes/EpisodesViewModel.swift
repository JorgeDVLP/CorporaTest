//
//  EpisodesViewModel.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

/*
 La segunda pantalla de la aplicación tendrá como título el nombre del personaje seleccionado y un listado vertical con los episodios en los que aparece. Los episodios serán agrupados en secciones según la temporada a la que pertenezcan: S01, S02, etc. No es necesario paginar la obtención de los episodios del personaje.
 Para la obtención de los capítulos de un personaje, no se puede utilizar el endpoint que permite obtener de una vez todos los capítulos, sino que habrá que hacer tantas llamadas al API como capítulos tenga el personaje.
 Además, para cada episodio se debe visualizar su título y su fecha de emisión en formato español (por ejemplo, la fecha “September 7, 2017” deberá transformarse en “7 de septiembre de 2017”).
 */

import Foundation

final class EpisodesViewModel {
    
    private let characterService: CharacterService
    private let character: Character
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    private var episodes: [Episode] = []
    
    var title: String {
        return character.name
    }
    
    var onDataFetched: (() -> Void)?
    
    init(characterService: CharacterService = APIManager.shared, character: Character) {
        self.characterService = characterService
        self.character = character
    }
    
    func fetchData() {
        self.episodes.removeAll()
        
        for url in character.episodes {
            fetchEpisode(url: url)
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All episodes fetched", self.episodes.count)
            self.episodes = self.episodes.sorted(by: { $0.episode < $1.episode })
            dump(self.episodes)
            self.onDataFetched?()
        }
    }
    
    private func fetchEpisode(url: String) {
        print("Fetching episode \(url)")
        self.dispatchGroup.enter()
        self.characterService.getEpisode(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let episode):
                self.episodes.append(episode)
            }
            self.dispatchGroup.leave()
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(forSection section: Int) -> Int {
        return self.episodes.count
    }
    
    func getItem(forIndex index: IndexPath) -> Episode {
        return self.episodes[index.row]
    }
}
