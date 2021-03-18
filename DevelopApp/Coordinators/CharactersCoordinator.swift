//
//  CharactersCoordinator.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation
import UIKit

protocol CharacterDetailsFlow: class {
    func coordinateToDetails(with character: Character)
}

final class CharactersCoordinator: Coordinator, CharacterDetailsFlow {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let startViewController = CharactersViewController.instantiate(storyboardName: "Main")
        startViewController.coordinator = self
        let startViewModel = CharactersViewModel()
        startViewModel.fetchData()
        startViewController.viewModel = startViewModel
        navigationController.pushViewController(startViewController, animated: true)
    }

    func coordinateToDetails(with details: Character) {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController, character: details)
        coordinate(to: detailsCoordinator)
    }
}
