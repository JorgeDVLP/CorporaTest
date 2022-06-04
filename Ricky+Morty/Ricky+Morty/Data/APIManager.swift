//
//  APIManager.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

enum APIError: Error {
    case badURL
    case requestError
    case badResponse
    case noData
    case dataCorrupted
}

protocol CharacterService {
    func getCharacters(page: Int, status: String?, completion: @escaping (_ result: Result<[Character], APIError>) -> Void)
    func getEpisode(url: String, completion: @escaping (_ result: Result<Episode, APIError>) -> Void)
}

final class APIManager: CharacterService {
    
    static let shared: CharacterService = APIManager()
    
    private init() {}
    
    func getCharacters(page: Int, status: String?, completion: @escaping (_ result: Result<[Character], APIError>) -> Void) {
                
        var urlComponents: URLComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        urlComponents.path = "/api/character"
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        if let status = status {
            queryItems.append(URLQueryItem(name: "status", value: status))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let mappedResponse = self.handleServerResponse(type: GenericAPIResponse<CharacterResult>.self, data: data, response: response, error: error)
            
            switch mappedResponse {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json):
                let result = json.results.map{ $0.toCharacter() }
                completion(.success(result))
            }
        }
        .resume()
    }
    
    func getEpisode(url: String, completion: @escaping (_ result: Result<Episode, APIError>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let mappedResponse = self.handleServerResponse(type: EpisodeResponse.self, data: data, response: response, error: error)
            
            switch mappedResponse {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json):
                let result = json.toEpisode()
                completion(.success(result))
            }
        }
        .resume()
    }
}

extension APIManager {
    func handleServerResponse<T: Decodable>(type: T.Type, data: Data?, response: URLResponse?, error: Error?) -> Result<T, APIError> {
        if let error = error {
            print(error.localizedDescription)
            return .failure(.requestError)
        }
        
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            return .failure(.badResponse)
        }
        
        guard let data = data else {
            return .failure(.noData)
        }

        guard let json = try? JSONDecoder().decode(T.self, from: data) else {
            return .failure(.dataCorrupted)
        }
    
        return .success(json)
    }
}
