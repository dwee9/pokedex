//
//  PokemonListItem.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import Foundation

struct PokemonListItem: Decodable, Identifiable, Hashable, Comparable {
    let id: Int
    let name: String

    private enum CodingKeys: String, CodingKey {
        case id = "url"
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeURLToID(forKey: .id)
        self.name = try container.decode(String.self, forKey: .name).capitalized
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    static func < (lhs: PokemonListItem, rhs: PokemonListItem) -> Bool {
        lhs.id < rhs.id
    }
}


struct PokemonListResponse: Decodable {
    let pokemon: [PokemonListItem]

    private enum CodingKeys: String, CodingKey {
        case pokemon = "results"
    }
}
