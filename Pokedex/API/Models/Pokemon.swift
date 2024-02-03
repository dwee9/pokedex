//
//  Pokemon.swift
//  Pokedex
//
//  Created by David Wee on 2/1/24.
//

import Foundation

struct Pokemon: Decodable, Equatable {

    let id: Int
    let name: String
    let baseExperience: Int
    let height: Int
    let weight: Int
    let abilities: [PokemonAbility]
    let moves: [PokemonMove]
    let stats: [PokemonStat]
    let types: [PokemonType]

    var heightInInches: Double {
        Double(height) / 4.536
    }

    var weightInLbs: Double {
        Double(weight) * 3.937
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case weight
        case abilities
        case moves
        case stats
        case types
    }
}

