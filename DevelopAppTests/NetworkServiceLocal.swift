//
//  NetworkServiceLocal.swift
//  DevelopAppTests
//
//  Created by Oleksiy Chebotarov on 16/07/2021.
//

import Foundation
@testable import DevelopApp

class NetworkServiceLocal: NetworkProtocol {
    private var charactersJson: String

    init(json: String) {
        charactersJson = json
    }
    
    func request(completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.success(charactersJson.data(using: .utf8)!))
    }
}
