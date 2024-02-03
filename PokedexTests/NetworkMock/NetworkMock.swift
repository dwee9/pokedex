//
//  NetworkMock.swift
//  PokedexTests
//
//  Created by David Wee on 1/31/24.
//

import Foundation
@testable import Pokedex

final class NetworkMock: Network {

    private lazy var mocks: [String: String] = happyPaths

    func request<T>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
        guard let response = mocks[endpoint.path] else {
            completion(.failure(.invalidResponse(error: nil, statusCode: -1)))
            return
        }
        
        completion(loadJSON(response, type: type))
    }

    func mock(endpoint: Endpoint, with responseFile: String) {
        mocks[endpoint.path] = responseFile
    }

    private func loadJSON<T: Decodable>(_ fileName: String, type: T.Type) -> Result<T, APIError> {
        guard let path = Bundle(for: NetworkMock.self).url(forResource: fileName, withExtension: "json") else {
            return .failure(.invalidURL)
        }

        do {
            let data = try Data(contentsOf: path)
            let object = try JSONDecoder().decode(type, from: data)
            return .success(object)
        } catch let error as DecodingError {
            return .failure(.decodingError(error))
        } catch {
            return .failure(.unknown(error))
        }
    }
}

// MARK: - Happy Path
private extension NetworkMock {

    var happyPaths: [String: String] {
        [
            PokemonEndpoint.getList.path : "pokemon_list_success",
            PokemonEndpoint.getPokemon(name: "Bulbasaur").path : "details_success",
            PokemonEndpoint.getPokemonSpecies(name: "bulbasaur").path : "species_success",
            PokemonEndpoint.getEvolution(id: 1).path : "evolutions_success"
        ]
    }
}
