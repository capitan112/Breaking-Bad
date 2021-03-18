//
//  CharacterCellViewModel.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation

protocol CharacterCellViewModelType {
    var imageURL: URL? { get }
    var name: String? { get }
}

struct CharacterCellViewModel: CharacterCellViewModelType {
    var character: Character?

    var imageURL: URL? {
        guard let url = character?.img else { return nil }

        return URL(string: url)
    }

    var name: String? {
        return character?.name
    }
}
