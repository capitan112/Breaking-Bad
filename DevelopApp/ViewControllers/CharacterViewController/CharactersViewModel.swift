//
//  CharactersViewModel.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation

protocol CharactersViewModelType {
    var characters: Bindable<[Character]?> { get set }
    func fetchData()
    func searchCharacters(by name: String) -> [Character]?
    func filterCharacters(by season: Int) -> [Character]?
}

class CharactersViewModel: CharactersViewModelType {
    @Injected private(set) var dataFetcher: NetworkDataFetcherProtocol
    var characters: Bindable<[Character]?> = Bindable(nil)

    func fetchData() {
        dataFetcher.fetchDetails(completion: { response in
            guard let characters = try? response.get() else { return }
            self.characters.value = characters
        })
    }

    func searchCharacters(by name: String) -> [Character]? {
        return characters.value?.filter { $0.name.lowercased().contains(name.lowercased()) }
    }

    func filterCharacters(by season: Int) -> [Character]? {
        return characters.value?.filter { $0.appearance.contains(season) }
    }
}
