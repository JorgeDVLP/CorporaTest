//
//  MainCoordinator.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // This func will take controll of the app navigation flow
    func start() {
        let vc = CharacterListViewController.instantiate()
        vc.viewModel = CharacterListViewModel()
        navigationController.pushViewController(vc, animated: false)
    }
}
