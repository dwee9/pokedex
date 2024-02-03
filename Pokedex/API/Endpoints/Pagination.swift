//
//  Pagination.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import Foundation

struct Pagination: Decodable {

    let offset: Int
    let limit: Int

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
    }

    init(offset: Int, limit: Int = 50) {
        self.offset = offset
        self.limit = limit
    }
}
