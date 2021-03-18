//
//  CharactersViewModel.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation

protocol CharactersViewModelType {
    var reload: Bindable<Void?> { get }
    var characters: [Character]? { get }
    var isFiltering: Bool { get set }
    var rows: Int { get }
    func fetchData()
    func searchCharacters(by name: String)
    func filterCharacters(by season: Int)
    func resetSearching()
}

class CharactersViewModel: CharactersViewModelType {
    var reload: Bindable<Void?> = Bindable(nil)

    private let dataFetcher = NetworkDataFetcher()
    var characters: [Character]? {
        return isFiltering ? searchingCharacters : originCharacters
    }

    var originCharacters: [Character]? = []
    var searchingCharacters: [Character]?
    var isFiltering = false
    var rows: Int {
        return isFiltering ? searchingCharacters?.count ?? 0 : originCharacters?.count ?? 0
    }

    func fetchData() {
        dataFetcher.fetchDetails(completion: { response in
            guard let characters = try? response.get() else { return }
            self.originCharacters = characters
            self.reload.value = ()
        })
    }

    func searchCharacters(by name: String) {
        searchingCharacters = originCharacters?.filter { $0.name.lowercased().contains(name.lowercased()) }
    }

    func filterCharacters(by season: Int) {
        searchingCharacters = originCharacters?.filter { $0.appearance.contains(season) }
    }

    func resetSearching() {
        isFiltering = false
        searchingCharacters = originCharacters
    }
}
