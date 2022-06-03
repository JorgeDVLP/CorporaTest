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
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.requestError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                completion(.failure(.badResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let json = try? JSONDecoder().decode(GenericAPIResponse<CharacterResult>.self, from: data) else {
                completion(.failure(.dataCorrupted))
                return
            }
            
            let result = json.results.map{ $0.toCharacter() }
            completion(.success(result))
        }
        .resume()
    }
}
