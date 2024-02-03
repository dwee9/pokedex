//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by David Wee on 2/2/24.
//

import Foundation

struct PokemonSpecies: Decodable {
    let happiness: Int
    let captureRate: Int
    let evolutionChainId: Int

    private enum CodingKeys: String, CodingKey {
        case happiness = "base_happiness"
        case captureRate = "capture_rate"
        case evolutionChainId = "evolution_chain"

        enum IdCodingKeys: String, CodingKey {
            case id = "url"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.happiness = try container.decode(Int.self, forKey: .happiness)
        self.captureRate = try container.decode(Int.self, forKey: .captureRate)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.IdCodingKeys.self, forKey: .evolutionChainId)
        self.evolutionChainId = try nested.decodeURLToID(forKey: .id)
    }
}
