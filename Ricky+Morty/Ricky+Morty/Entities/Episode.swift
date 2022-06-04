//
//  Episode.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation

struct Episode {
    let id: Int
    let name: String
    let date: String
    let episode: String
    
    var season: String {
        let substring = episode.prefix(3)
        return String(substring)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM d, Y"
        return formatter
    }()
    
    private let spanishDateFormatter: DateFormatter = {
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
}
