//
//  PokemonStat.swift
//  Pokedex
//
//  Created by David Wee on 2/2/24.
//

import Foundation

struct PokemonStat: Decodable, Identifiable, Comparable {
    let id: Int
    let base: Int
    let effort: Int
    let name: String

    private enum CodingKeys: String, CodingKey {
        case base = "base_stat"
        case effort
        case stat
    }

    private enum ChildCodingKeys: String, CodingKey {
        case name
        case id = "url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.base = try container.decode(Int.self, forKey: .base)
        self.effort = try container.decode(Int.self, forKey: .effort)
        
        let nested = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .stat)
        self.name = try nested.decode(String.self, forKey: .name).capitalized.replacingOccurrences(of: "-", with: " ")
        self.id = try nested.decodeURLToID(forKey: .id)
    }

    static func < (lhs: PokemonStat, rhs: PokemonStat) -> Bool {
        lhs.name < rhs.name
    }
}
