//
//  Endpoint.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidEncoding
    case decodingError(DecodingError)
    case invalidResponse(error:Error?, statusCode: Int)
    case unknown(Error)
}

enum RequestMethod: String {
    case get = "GET"
}

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var url: URL? { get }
    var method: RequestMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
}

extension Endpoint {

    var scheme: String { "https" }

    var host: String { "pokeapi.co" }

    var body: Encodable? { nil }

    var queryParameters: [String: AnyHashable]? { nil }

    var responseType: Decodable? { nil }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        if let queryItems {
            components.queryItems = queryItems
        }
        return components.url
    }

    func request() throws -> URLRequest {

        guard let url  else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(body)
                request.httpBody = data
            } catch {
                throw APIError.invalidEncoding
            }
        }
        return request
    }
}

