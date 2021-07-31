//
//  TestDependencyGraph.swift
//  DevelopAppTests
//
//  Created by Oleksiy Chebotarov on 31/07/2021.
//

@testable import DevelopApp
import Foundation

final public class TestDependencyGraph {
    static func registerLocalSerives(for resolver: Resolver = .main) {
        resolver.register { NetworkServiceLocal(json: charactersJson) as NetworkProtocol }
        resolver.register { NetworkDataFetcher() as NetworkDataFetcherProtocol }
        resolver.register { CharactersViewModel() as CharactersViewModelType }
        resolver.register { DetailsViewModel() as DetailsViewModelType }
    }

    static func registerMockCharactersViewModel(for resolver: Resolver = .main) {
        resolver.register { MockCharactersViewModel() as CharactersViewModelType }
    }
}
