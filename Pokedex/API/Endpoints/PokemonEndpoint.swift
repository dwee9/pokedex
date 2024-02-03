//
//  PokemonEndpoint.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import Foundation

enum PokemonEndpoint: Endpoint {

    case getList
    case getPokemon(name: String)
    case getImage(id: Int)
    case getPokemonSpecies(name: String)
    case getEvolution(id: Int)

    var host: String {
        switch self {
        case .getImage:
            return "raw.githubusercontent.com"
        case .getList, .getPokemon, .getEvolution, .getPokemonSpecies:
            return "pokeapi.co"
        }
    }

    var path: String {
        switch self {
        case .getList:
            return "/api/v2/pokemon"
        case .getPokemon(let name):
            return "/api/v2/pokemon/\(name.lowercased())"
        case .getImage(let id):
            return "/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        case .getPokemonSpecies(let name):
            return "/api/v2/pokemon-species/\(name.lowercased())"
        case .getEvolution(let id):
            return "/api/v2/evolution-chain/\(id)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getList:
            return Pagination(offset: 0, limit: 2000).queryItems
        default:
            return nil
        }
    }

    var method: RequestMethod { .get }
}
