//
//  NetworkService.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation

protocol NetworkProtocol {
    func request(completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: NetworkProtocol {
    func request(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = urlFromParameters() else {
            completion(.failure(NSError(domain: "URL string error", code: -1, userInfo: nil)))

            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    private func createDataTask(from request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            if error != nil || data == nil {
                completion(.failure(error!))
                return
            }

            guard let response = response as? HTTPURLResponse, (200 ... 299).contains(response.statusCode) else {
                completion(.failure(ConversionFailure.responceError))
                return
            }

            guard let data = data else {
                completion(.failure(ConversionFailure.invalidData))
                return
            }

            completion(.success(data))
        })
    }

    private func urlFromParameters() -> URL? {
        var components = URLComponents()
        components.scheme = RequestConstant.Server.APIScheme
        components.host = RequestConstant.Server.APIHost
        components.path = RequestConstant.Server.APIPath

        return components.url
    }
}
