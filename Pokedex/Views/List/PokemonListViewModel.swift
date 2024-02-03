//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import Combine
import Foundation

final class PokemonListViewModel: ObservableObject {

    private var cancellables = Set<AnyCancellable>()
    
    private let network: Network

    @Published private(set) var isLoading: Bool = false

    @Published private(set) var pokemonList: [PokemonListItem] = []
    @Published var searchText: String = ""

    init(network: Network = DefaultNetwork()) {
        self.network = network
        loadPokemon()
    }

    /// A filtered list of pokemon
    /// - returns: `[PokemonListItem]`
    func filteredPokemon() -> [PokemonListItem] {
        guard !searchText.isEmpty else { return pokemonList }
        return pokemonList.filter { $0.name.localizedStandardContains(searchText) }
    }

    /// Loads the list of pokemon
    func loadPokemon() {
        isLoading = true
        network.request(endpoint: PokemonEndpoint.getList, type: PokemonListResponse.self) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.pokemonList = response.pokemon
                case .failure(let error):
                    print(error)
                    self.pokemonList = []
                }

                self.isLoading = false
            }
        }
    }
}
