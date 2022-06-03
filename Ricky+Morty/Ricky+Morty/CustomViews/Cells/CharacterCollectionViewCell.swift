//
//  CharacterCollectionViewCell.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier: String = "CharacterCell"
    @IBOutlet weak var titleLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "CharacterCollectionViewCell", bundle: .main)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
