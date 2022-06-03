//
//  EpisodeTableViewCell.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "EpisodeCell"

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "EpisodeTableViewCell", bundle: .main)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.title.text = "-"
        self.date.text = "-"
    }
}
