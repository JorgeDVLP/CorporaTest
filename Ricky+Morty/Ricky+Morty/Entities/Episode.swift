//
//  Episode.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

struct Episode: Decodable {
    let id: Int
    let name: String
    let date: String
    let episode: String
    
    var season: String {
        let substring = episode.prefix(3)
        return String(substring)
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM d, Y"
        return formatter
    }()
    
    private var spanishDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateStyle = .long
        return formatter
    }()
    
    var localizedDate: String {
        guard let newDate = self.dateFormatter.date(from: date) else {
            return date
        }
        
        return spanishDateFormatter.string(from: newDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case date = "air_date"
        case episode = "episode"
    }
}
