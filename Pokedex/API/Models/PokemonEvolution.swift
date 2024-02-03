//
//  PokemonEvolution.swift
//  Pokedex
//
//  Created by David Wee on 2/2/24.
//

import Foundation

struct EvolutionChainResponse: Decodable {
    let id: Int

    enum CodingKeys: CodingKey {
        case id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeURLToID(forKey: .id)
    }
}

struct PokemonEvolutionChain: Decodable {
    let chain: PokemonEvolution
}

struct PokemonEvolution: Decodable, Hashable, Equatable {
    let evolutions: [PokemonListItem]

    private enum CodingKeys: String, CodingKey {
        case evolvesTo = "evolves_to"
        case species
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let value = try container.decode(PokemonNameIdValue.self, forKey: .species)

        var evolutions = [PokemonListItem(id: value.id, name: value.name)]

        if let evolvesTo = try? container.decodeIfPresent([PokemonEvolution].self, forKey: .evolvesTo), !evolvesTo.isEmpty {
            let next = evolvesTo.flatMap { $0.evolutions }
            evolutions.append(contentsOf: next)
        }
        self.evolutions = evolutions
    }
}
