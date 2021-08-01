//
//  GraphDependacy.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 31/07/2021.
//

import Foundation

final public class DependencyGraph {
    static func registerAllComponents(for resolver: Resolver = .main) {
        resolver.register { NetworkService() as NetworkProtocol }
        resolver.register { NetworkDataFetcher() as NetworkDataFetcherProtocol }
        resolver.register { CharactersViewModel() as CharactersViewModelType }
        resolver.register { DetailsViewModel() as DetailsViewModelType }
    }
}
