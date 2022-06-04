//
//  IndicatorCell.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 4/6/22.
//

import UIKit
class IndicatorCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "IndicatorCell"
    
    var inidicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        contentView.addSubview(inidicator)
        self.inidicator.center = contentView.center
        inidicator.startAnimating()
    }
    
}
