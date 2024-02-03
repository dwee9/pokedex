//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by David Wee on 2/1/24.
//

import Foundation
import Combine

final class PokemonDetailViewModel: ObservableObject {

    private var cancellables = Set<AnyCancellable>()

    private let network: Network

    let pokemonName: String
    let pokemonId: Int

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var pokemon: Pokemon?
    @Published private(set) var species: PokemonSpecies?
    @Published private(set) var evolutions: PokemonEvolution?

    // The height the pokemon in inches
    var heightString: String {
        guard let pokemon else { return "" }
        return String(format:Strings.Detail.heightValue, pokemon.heightInInches)
    }

    // The weight of the pokemon in lbs
    var weightString: String {
        guard let pokemon else { return "" }
        return String(format:Strings.Detail.weightValue, pokemon.weightInLbs)
    }

    init(pokemonListItem: PokemonListItem, network: Network = DefaultNetwork()) {
        self.network = network
        self.pokemonName = pokemonListItem.name
        self.pokemonId = pokemonListItem.id
        reload()
    }

    /// Reloads the Pokemon Details
    func reload() {
        setupSubscribers()
        loadPokemon()
        loadSpecies()
    }
}

// MARK: - Private
private extension PokemonDetailViewModel {

    func loadPokemon() {
        isLoading = true
        network.request(endpoint: PokemonEndpoint.getPokemon(name: pokemonName), type: Pokemon.self) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.pokemon = try? result.get()
            }
        }
    }

    func loadSpecies() {
        network.request(endpoint: PokemonEndpoint.getPokemonSpecies(name: pokemonName), type: PokemonSpecies.self) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let species = try? result.get() {
                    self.species = species
                    self.loadEvolutions(id: species.evolutionChainId)
                } else {
                    self.species = nil
                    self.evolutions = nil
                }
            }
        }
    }

    func loadEvolutions(id: Int) {
        network.request(endpoint: PokemonEndpoint.getEvolution(id: id), type: PokemonEvolutionChain.self) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.evolutions = (try? result.get())?.chain
            }
        }
    }

    func setupSubscribers() {
        var cancellable: AnyCancellable?
        cancellable = Publishers.CombineLatest3($pokemon.dropFirst(), $species.dropFirst(), $evolutions.dropFirst())
            .receive(on: RunLoop.main).sink { [weak self] _ in
                self?.isLoading = false
                cancellable = nil
            }
    }
}
