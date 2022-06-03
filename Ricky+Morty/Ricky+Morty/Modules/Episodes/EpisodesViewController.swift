//
//  EpisodesViewController.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

class EpisodesViewController: UIViewController, StoryBoarded {

    var viewModel: EpisodesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
    }

}
