//
//  CharacterTests.swift
//  Ricky+MortyTests
//
//  Created by Jorge Martin Moreno on 4/6/22.
//

import XCTest

@testable import Ricky_Morty
class CharacterTests: XCTestCase {
    var characterService: CustomCharacterService!
    var characters: [Character] = []
    var viewModel: CharacterListViewModel!

    override func setUpWithError() throws {
        characterService = CustomCharacterService()
        characters = [
            Character(id: 1, name: "Ricky", origin: "Earth", status: .alive, imageURL: "", episodes: ["Episode 1", "Episode 2"]),
            Character(id: 2, name: "Morty", origin: "Earth", status: .dead, imageURL: "", episodes: ["Episode 1", "Episode 2"]),
            Character(id: 3, name: "Jerry", origin: "Earth", status: .unknown, imageURL: "", episodes: ["Episode 1"]),
            Character(id: 4, name: "Beth", origin: "Earth", status: .unknown, imageURL: "", episodes: ["Episode 1", "Episode 2", "Episode 3"])]
        
        viewModel = CharacterListViewModel(characterService: characterService)
        
    }

    override func tearDownWithError() throws {
        characterService = nil
        characters = []
        viewModel = nil
    }

    func testFetchCharacters() throws {
        
        let expectation = expectation(description: "test")
        
        characterService.result = .success(characters)
        
        viewModel.onDataFetched = { count in
            XCTAssertTrue(count == 4)
            XCTAssertEqual(self.viewModel.numberOfSections(), 1)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 4)

            expectation.fulfill()
        }
        
        viewModel.fetchData()
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchCharactersWithError() {
        let expectation = expectation(description: "test")
        
        characterService.result = .failure(.badResponse)
        
        viewModel.onError = { message in
            XCTAssertFalse(message.isEmpty)
            XCTAssertEqual(self.viewModel.numberOfSections(), 1)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 0)
            expectation.fulfill()
        }
        
        viewModel.fetchData()
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchNewPageData() {
        let expectation = expectation(description: "test")
        characterService.result = .success(characters)
        
        viewModel.fetchData()
        
        characterService.result = .success([Character(id: 5, name: "Annie", origin: "Earth", status: .alive, imageURL: "", episodes: [""])])
        
        viewModel.onDataAdded = { _ in
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 5)
            let item = self.viewModel.getItem(forIndex: IndexPath(row: 4, section: 0))
            XCTAssertEqual(item.name, "Annie")
            expectation.fulfill()
        }
        
        viewModel.fetchNextPage()

        waitForExpectations(timeout: 1.5)
    }
    
    func testAllFilter() {
        let expectation = expectation(description: "test")
        
        characterService.result = .success(characters)
        
        viewModel.onDataFetched = { count in
            XCTAssertTrue(count == 4)
            XCTAssertEqual(self.viewModel.numberOfSections(), 1)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 4)

            expectation.fulfill()
        }
        
        viewModel.onFilterChanged(index: 0)
        
        waitForExpectations(timeout: 1)
    }
    
    func testAliveFilter() {
        let expectation = expectation(description: "test")
        
        characterService.result = .success(characters)
        
        viewModel.onDataFetched = { count in
            XCTAssertTrue(count == 1)
            XCTAssertEqual(self.viewModel.numberOfSections(), 1)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 1)

            expectation.fulfill()
        }
        
        viewModel.onFilterChanged(index: 1)
        
        waitForExpectations(timeout: 1)
    }
    
    func testDeadFilter() {
        let expectation = expectation(description: "test")
        
        characterService.result = .success(characters)
        
        viewModel.onDataFetched = { count in
            XCTAssertTrue(count == 1)
            XCTAssertEqual(self.viewModel.numberOfSections(), 1)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 1)

            expectation.fulfill()
        }
        
        viewModel.onFilterChanged(index: 2)
        
        waitForExpectations(timeout: 1)
    }
    
    func testUnknownFilter() {
        let expectation = expectation(description: "test")
        
        characterService.result = .success(characters)
        
        viewModel.onDataFetched = { count in
            XCTAssertEqual(count, 2)
            XCTAssertEqual(self.viewModel.numberOfSections(), 1)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 2)

            expectation.fulfill()
        }
        
        viewModel.onFilterChanged(index: 3)
        
        waitForExpectations(timeout: 1)
    }
    
    func testFilterWithUnknownIndex() {
        let expectation = expectation(description: "test")
        
        characterService.result = .success(characters)
        
        viewModel.onDataFetched = { count in
            XCTAssertTrue(count == 4)
            XCTAssertEqual(self.viewModel.numberOfSections(), 1)
            XCTAssertEqual(self.viewModel.numberOfItems(forSection: 0), 4)

            expectation.fulfill()
        }
        
        viewModel.onFilterChanged(index: 8)
        
        waitForExpectations(timeout: 1)
    }
    
    func testShowIndicator() {
        let expectation = expectation(description: "test")
        
        characterService.result = .success(characters)
        
        var count: Int = 0
        /*
         this should be called twice, before fetching data and when fetch is completed
         */
        viewModel.onShouldDisplayIndicator = { show in
            count += 1
        }
        
        viewModel.fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(count, 2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    class CustomCharacterService: CharacterService {
        
        var result: Result<[Character], APIError>?
        
        func getCharacters(page: Int, status: String?, completion: @escaping (Result<[Character], APIError>) -> Void) {
            if let result = result {
                if let status = status {
                    switch result {
                    case .failure(_):
                        completion(result)
                    case .success(let characters):
                        let filtered = characters.filter({ $0.status.rawValue.lowercased() == status})
                        completion(.success(filtered))
                    }
                } else {
                    completion(result)
                }
            }
        }
        
        func getEpisode(url: String, completion: @escaping (Result<Episode, APIError>) -> Void) {
            
        }
    }
}
