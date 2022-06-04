//
//  EpisodeTests.swift
//  Ricky+MortyTests
//
//  Created by Jorge Martin Moreno on 4/6/22.
//

import XCTest

@testable import Ricky_Morty
class EpisodeTests: XCTestCase {

    var viewModel: EpisodesViewModel!
    var characterService: CustomCharacterService!
    var character: Character!
    let defaultEpisode = Episode(id: 1, name: "Episode 1", date: "July 8, 2016", episode: "S0101")
    
    override func setUpWithError() throws {
        characterService = CustomCharacterService()
        character = .init(id: 1, name: "Ricky", origin: "Earth", status: .alive, imageURL: "", episodes: ["Episode1"])
        viewModel = EpisodesViewModel(characterService: characterService, character:  character)
    }

    override func tearDownWithError() throws {
        characterService = nil
    }

    func testCharacterName() throws {
        XCTAssertEqual(viewModel.title, "Ricky")
    }
    
    func testFetchDataOneSeason() {

        let expectation = expectation(description: "test")
        
        let episode = defaultEpisode
        
        characterService.result = Result.success(episode)
        viewModel.onDataFetched = {
            XCTAssertEqual(self.viewModel.numberOfSections(), 1)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 1)
            let item = self.viewModel.getItem(forIndex: IndexPath(row: 0, section: 0))
            XCTAssertEqual(item.id, 1)
            XCTAssertEqual(item.name, "Episode 1")
            expectation.fulfill()
        }
        
        viewModel.fetchData()
            
        waitForExpectations(timeout: 1)
    }
    
    func testFetchDataMultipleSeasons() {

        let expectation = expectation(description: "test")
        
        character = .init(id: 1, name: "Ricky", origin: "Earth", status: .alive, imageURL: "", episodes: ["Episode1","Episode2","Episode3","Episode4","Episode5","Episode6"])
        
        viewModel = EpisodesViewModel(characterService: characterService, character:  character)
        
        var episodes: [Episode] = []
        var id: Int = 1
        for i in 1..<3 {
            for j in 1...3 {
                let season = "S0\(i)0\(j)"
                episodes.append(.init(id: id, name: "Episode \(id)", date: "December 6, 2016", episode: season))
                id += 1
            }
        }
    
        viewModel.onDataFetched = {
            XCTAssertEqual(self.viewModel.numberOfSections(), 2)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 3)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 1), 3)

            let item = self.viewModel.getItem(forIndex: IndexPath(row: 2, section: 1))
            XCTAssertEqual(item.id, 6)
            XCTAssertEqual(item.name, "Episode 6")
            expectation.fulfill()
        }
        
        characterService.episodes = episodes
        viewModel.fetchData()
            
        waitForExpectations(timeout: 1)
    }
    
    func testFetchDataWithError() {
        let expectation = expectation(description: "test")

        characterService.result = .failure(.badURL)
        
        viewModel.onError = { message in
            XCTAssertTrue(!message.isEmpty)
            XCTAssertEqual(message, "Error trying fetching episodes")
            XCTAssertTrue(self.viewModel.numberOfSections() == 0)
            expectation.fulfill()
        }
        
        viewModel.fetchData()
        
        waitForExpectations(timeout: 1)

    }
    
    // This method will test that display indicator is called twice during a fetch, one for true and other for false
    func testShowIndicator() {
        let expectation = expectation(description: "test")

        let mockedView = MockedView(viewModel: viewModel)
        mockedView.bindView()
        characterService.result = .success(defaultEpisode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockedView.showIndicatorCount == 2)
            XCTAssertTrue(mockedView.atleastOneTrue)
            expectation.fulfill()
        }
        
        viewModel.fetchData()
        
        waitForExpectations(timeout: 1.5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class CustomCharacterService: CharacterService {
    
    var result: Result<Episode, APIError>?
    var episodes: [Episode] = []
    
    func getCharacters(page: Int, status: String?, completion: @escaping (Result<[Character], APIError>) -> Void) {
        
    }
    
    func getEpisode(url: String, completion: @escaping (Result<Episode, APIError>) -> Void) {
        if let result = result {
            completion(result)
        } else {
            completion(.success(episodes.removeFirst()))
        }
    }
}

class MockedView {
    let viewModel: EpisodesViewModel
    var showIndicatorCount: Int = 0
    var atleastOneTrue: Bool = false
    
    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
    }
    
    func increaseIndicator() {
        showIndicatorCount += 1
    }
    
    func bindView() {
        viewModel.onShouldDisplayIndicator = { [weak self] show in
            self?.increaseIndicator()
            if show == true {
                self?.atleastOneTrue = true
            }
        }
    }
}
