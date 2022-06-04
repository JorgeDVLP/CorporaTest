//
//  Extensions.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 4/6/22.
//

import UIKit

extension UIViewController {
    func showActivityIndicator() {
        if let _ = restoreIndicator() { return }
        
        let indicator : UIActivityIndicatorView = {
            let view = UIActivityIndicatorView()
            view.style = .large
            return view
        }()
        
        indicator.center = view.center
        indicator.startAnimating()
        indicator.tag = 0x10
        self.view.addSubview(indicator)
    }
    
    func removeActivityIndicator() {
        guard let indicator = restoreIndicator() else { return }
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    private func restoreIndicator() -> UIActivityIndicatorView? {
        return self.view.subviews.first(where: { $0.tag == 0x10 }) as? UIActivityIndicatorView
    }
}
