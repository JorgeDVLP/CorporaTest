//
//  CellDrawer.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 4/6/22.
//

import Foundation
import UIKit

protocol DrawStrattegy {
    associatedtype CellViewModel
    func draw(_ cell: UICollectionViewCell, model: CellViewModel)
}

struct CellDrawer<T: DrawStrattegy> {
    let strattegy: T
    
    func draw(_ cell: UICollectionViewCell, model: T.CellViewModel) {
        strattegy.draw(cell, model: model)
    }
}

struct CharacterStrattegy: DrawStrattegy {
    typealias CellViewModel = Character
    
    func draw(_ cell: UICollectionViewCell, model: Character) {
        guard let cell = cell as? CharacterCollectionViewCell else { return }
        let item = model
        cell.nameLabel.text = item.name
        cell.statusLabel.text = item.status.rawValue
        cell.originLabel.text = item.origin
        
        switch item.status {
        case .alive:
            cell.statusLabel.textColor = UIColor(named: "GreenColor")
        case .dead:
            cell.statusLabel.textColor = UIColor(named: "RedColor")
        case .unknown:
            cell.statusLabel.textColor = UIColor(named: "UnknownColor")
        }
        
        let representableID = item.id
        cell.representableID = representableID
        
        ImageCache.loadImage(urlString: item.imageURL) { image in
            if cell.representableID == representableID {
                cell.image.image = image
            }
        }
    }
}


