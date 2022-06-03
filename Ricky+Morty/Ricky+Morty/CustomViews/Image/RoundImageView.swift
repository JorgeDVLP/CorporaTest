//
//  RoundImageView.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit
class RoundImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2.0

    }

}
