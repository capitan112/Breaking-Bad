//
//  NetworkDataFetcher.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation

enum ConversionFailure: Error {
    case invalidData
    case missingData
    case responceError
}

protocol NetworkDataFetcherProtocol {
    func fetchDetails(completion: @escaping (Result<[Character], Error>) -> Void)
    func fetchGenericJSONData(response: @escaping (Result<[Character], Error>) -> Void)
}

final class NetworkDataFetcher: NetworkDataFetcherProtocol {
    var networking: NetworkProtocol

    init(networking: NetworkProtocol = NetworkService()) {
        self.networking = networking
    }

    func fetchDetails(completion: @escaping (Result<[Character], Error>) -> Void) {
        fetchGenericJSONData(response: completion)
    }

    func fetchGenericJSONData(response: @escaping (Result<[Character], Error>) -> Void) {
        networking.request { dataResponse in
            guard let data = try? dataResponse.get() else {
                response(.failure(ConversionFailure.responceError))
                return
            }

            self.decodeJSON(from: data, completion: response)
        }
    }

    private func decodeJSON(from data: Data?, completion: @escaping (Result<[Character], Error>) -> Void) {
        guard let data = data else {
            completion(.failure(ConversionFailure.missingData))
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let result = Result(catching: {
                try decoder.decode([Character].self, from: data)
            })

            completion(result)
        }
    }
}
