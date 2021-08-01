//
//  TestDependencyGraph.swift
//  DevelopAppTests
//
//  Created by Oleksiy Chebotarov on 31/07/2021.
//

@testable import DevelopApp
import Foundation

extension DependencyGraph {
    static func registerLocalNetwork(for resolver: Resolver = .main) {
        resolver.register { NetworkServiceLocal(json: charactersJson) as NetworkProtocol }
    }
}
