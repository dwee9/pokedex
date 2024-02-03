//
//  PokemonAbility.swift
//  Pokedex
//
//  Created by David Wee on 2/1/24.
//

import Foundation

struct PokemonAbility: Decodable, Identifiable, Comparable {
    var id: Int { ability.id }
    let ability: PokemonNameIdValue

    static func < (lhs: PokemonAbility, rhs: PokemonAbility) -> Bool {
        lhs.ability.name < rhs.ability.name
    }
}

struct PokemonMove: Decodable, Identifiable, Comparable {
    var id: Int { move.id }
    let move: PokemonNameIdValue

    static func < (lhs: PokemonMove, rhs: PokemonMove) -> Bool {
        lhs.move.name < rhs.move.name
    }
}

struct PokemonType: Decodable, Identifiable, Comparable {
    var id: Int { type.id }
    let type: PokemonNameIdValue

    static func < (lhs: PokemonType, rhs: PokemonType) -> Bool {
        lhs.type.name < rhs.type.name
    }
}


struct PokemonNameIdValue: Decodable, Identifiable, Equatable {

    let id: Int
    let name: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeURLToID(forKey: .id)
        self.name = try container.decode(String.self, forKey: .name).capitalized.replacingOccurrences(of: "-", with: " ")
    }


    private enum CodingKeys: String, CodingKey {
        case id = "url"
        case name
    }
}
