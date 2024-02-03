//
//  Network.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import Foundation
import Combine

protocol Network {
    func request<T: Decodable>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

final class DefaultNetwork: Network {

    private var session: URLSession {
        let config: URLSessionConfiguration = .default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        return URLSession(configuration: config)
    }

    /// Sends a request to the Network
    /// - Parameters:
    ///    - endpoint: The `Endpoint` to send the request to
    ///    - type: The expected return type
    ///    - completion: `(Result<T, APIError>) -> Void`
    func request<T: Decodable>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let task = session.dataTask(with: try endpoint.request()) { data, response, error in
                guard let response = response as? HTTPURLResponse, let data else {
                    completion(.failure(.invalidResponse(error: error, statusCode: -1)))
                    return
                }

                switch response.statusCode {
                case 200...299:
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(model))
                    } catch let error as DecodingError {
                        completion(.failure(.decodingError(error)))
                    } catch {
                        completion(.failure(.unknown(error)))
                    }
                default:
                    completion(.failure(.invalidResponse(error: error, statusCode: response.statusCode)))
                }
            }

            task.resume()

        } catch let error as APIError {
            completion(.failure(error))
        } catch {
            completion(.failure(.unknown(error)))
        }
    }
}
