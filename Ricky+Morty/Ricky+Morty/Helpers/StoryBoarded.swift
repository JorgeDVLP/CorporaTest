//
//  StoryBoarded.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation
import UIKit

protocol StoryBoarded {
    static func instantiate() -> Self
}

/*
    This func will be used to instantiate viewcontrollers from storyboard easily
    id always must match with viewcontroller's name, thats why 'as! Self' cast is always Safe
 */
extension StoryBoarded where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let id = String(describing: self)
        let vc = storyboard.instantiateViewController(withIdentifier: id) as! Self
        return vc
    }
}
