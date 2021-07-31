//
//  DetailsCoordinator.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation
import UIKit

final class DetailsCoordinator: Coordinator {
    let navigationController: UINavigationController
    var character: Character

    init(navigationController: UINavigationController, character: Character) {
        self.navigationController = navigationController
        self.character = character
    }

    func start() {
        let detailsViewController = DetailsViewController.instantiate(storyboardName: "Main")
        detailsViewController.viewModel.character = character
        navigationController.present(detailsViewController, animated: true)
    }
}
