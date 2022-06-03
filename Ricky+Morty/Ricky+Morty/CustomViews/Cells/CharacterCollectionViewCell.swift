//
//  CharacterCollectionViewCell.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier: String = "CharacterCell"
    
    @IBOutlet weak var image: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    private lazy var placeholderImg: UIImage? = {
       return UIImage(named: "placeholder")
    }()
    
    static func nib() -> UINib {
        return UINib(nibName: "CharacterCollectionViewCell", bundle: .main)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = "-"
        self.originLabel.text = "-"
        self.statusLabel.text = "-"
        self.statusLabel.textColor = .secondaryLabel
        self.image.image = placeholderImg
    }

}
