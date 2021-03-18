//
//  DetailsViewModel.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation

protocol DetailsViewModelType {
    var imageURL: URL? { get }
    var name: String { get }
    var occupation: String { get }
    var status: String { get }
    var nickname: String { get }
    var seasonAppearance: String { get }
}

class DetailsViewModel: DetailsViewModelType {
    var imageURL: URL? {
        return URL(string: character.img)
    }

    var name: String {
        return character.name
    }

    var occupation: String {
        return character.occupation.joined(separator: "\n")
    }

    var status: String {
        let status = NSLocalizedString("Status: ", comment: "status of charcter")
        return status + character.status.rawValue
    }

    var nickname: String {
        return "Nickname: " + character.nickname
    }

    var seasonAppearance: String {
        let seasonAppearance = NSLocalizedString("Season appearance: \n", comment: "Season appearance of charcter")
        return seasonAppearance + character.appearance.map { String($0) }.joined(separator: ", ")
    }

    private let character: Character

    init(character: Character) {
        self.character = character
    }
}
