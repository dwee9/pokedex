//
//  PokemonDetailViewModelTests.swift
//  PokedexTests
//
//  Created by David Wee on 2/2/24.
//

import Combine
import Foundation
@testable import Pokedex
import XCTest

final class PokemonDetailViewModelTests: XCTestCase {

    var viewModel: PokemonDetailViewModel!
    var networkMock: NetworkMock! = NetworkMock()

    override func setUp() {
        super.setUp()
        viewModel = PokemonDetailViewModel(pokemonListItem: PokemonListItem(id: 1, name: "Bulbasaur"), network: networkMock)
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        networkMock = nil
    }

    private func loadDetails() {
        let expectaion = expectation(description: "Wait for pokemon details")
        var cancellable: AnyCancellable?

        cancellable = Publishers.CombineLatest3(viewModel.$pokemon.dropFirst(), viewModel.$species.dropFirst(), viewModel.$evolutions.dropFirst()).sink { _ in
            expectaion.fulfill()
            cancellable = nil
        }
        viewModel.reload()
        waitForExpectations(timeout: 2.0)
    }

    func testSuccessfulDetailsFetch() {
        // When all calls are successful
        loadDetails()

        XCTAssertEqual(viewModel.pokemon?.name, "bulbasaur")
        XCTAssertEqual(viewModel.pokemon?.height, 7)
        XCTAssertEqual(viewModel.pokemon?.weight, 69)
        XCTAssertEqual(viewModel.pokemon?.baseExperience, 64)
        XCTAssertEqual(viewModel.pokemon?.moves.count, 2)
        XCTAssertTrue(viewModel.pokemon!.types.contains(where: { $0.type.name == "Grass"}))
        XCTAssertTrue(viewModel.pokemon!.abilities.contains(where: { $0.ability.name == "Overgrow" }))

        XCTAssertEqual(viewModel.species?.captureRate, 45)
        XCTAssertEqual(viewModel.species?.happiness, 50)
        XCTAssertEqual(viewModel.species?.evolutionChainId, 1)

        XCTAssertTrue(viewModel.evolutions!.evolutions.contains(where: { $0.name == "Bulbasaur"}))
        XCTAssertTrue(viewModel.evolutions!.evolutions.contains(where: { $0.name == "Ivysaur"}))
        XCTAssertTrue(viewModel.evolutions!.evolutions.contains(where: { $0.name == "Venusaur"}))
    }

    func testInvalidSpeciesFetch() {
        networkMock.mock(endpoint: PokemonEndpoint.getPokemonSpecies(name: "bulbasaur"), with: "species_malformed")
        // When details call is invalid
        loadDetails()

        // Pokemon Details should still be valid
        XCTAssertEqual(viewModel.pokemon?.name, "bulbasaur")
        XCTAssertEqual(viewModel.pokemon?.height, 7)
        XCTAssertEqual(viewModel.pokemon?.weight, 69)
        XCTAssertEqual(viewModel.pokemon?.baseExperience, 64)
        XCTAssertEqual(viewModel.pokemon?.moves.count, 2)
        XCTAssertTrue(viewModel.pokemon!.types.contains(where: { $0.type.name == "Grass"}))
        XCTAssertTrue(viewModel.pokemon!.abilities.contains(where: { $0.ability.name == "Overgrow" }))

        // Species should be nil
        XCTAssertNil(viewModel.species)

        // Evolutions should be nil
        XCTAssertNil(viewModel.evolutions)
    }

    func testInvalidEvolutionsFetch() {

        // When Evolutions call is invalid
        networkMock.mock(endpoint: PokemonEndpoint.getEvolution(id: 1), with: "evolutions_malformed")
        loadDetails()

        // Pokemon Details should still be valid
        XCTAssertEqual(viewModel.pokemon?.name, "bulbasaur")
        XCTAssertEqual(viewModel.pokemon?.height, 7)
        XCTAssertEqual(viewModel.pokemon?.weight, 69)
        XCTAssertEqual(viewModel.pokemon?.baseExperience, 64)
        XCTAssertEqual(viewModel.pokemon?.moves.count, 2)
        XCTAssertTrue(viewModel.pokemon!.types.contains(where: { $0.type.name == "Grass"}))
        XCTAssertTrue(viewModel.pokemon!.abilities.contains(where: { $0.ability.name == "Overgrow" }))
        XCTAssertEqual(viewModel.pokemon?.stats.count, 6)

        // Species should still be valid
        XCTAssertEqual(viewModel.species?.captureRate, 45)
        XCTAssertEqual(viewModel.species?.happiness, 50)
        XCTAssertEqual(viewModel.species?.evolutionChainId, 1)

        // Evoilutions should ne nil
        XCTAssertNil(viewModel.evolutions)
    }

    func testPokemonStasConversions() {
        loadDetails()
        XCTAssertEqual(viewModel.heightString, "1.5 in")
        XCTAssertEqual(viewModel.weightString, "271.7 lbs")
    }

    func testURLToIdDecoding() {
        // When loaded sucessfully
        loadDetails()

        // Id should be properly decoded
        XCTAssertEqual(viewModel.pokemon?.id, 1)
    }

    func testValuesSorting() {
        loadDetails()

        // All Values should be sorted alphabetically by name
        XCTAssertEqual(viewModel.evolutions?.evolutions.sorted().map { $0.name }, ["Bulbasaur", "Ivysaur", "Venusaur"])
        XCTAssertEqual(viewModel.pokemon?.stats.sorted().map { $0.name }, ["Attack", "Defense", "Hp", "Special Attack", "Special Defense", "Speed"])
        XCTAssertEqual(viewModel.pokemon?.types.sorted().map { $0.type.name }, ["Grass", "Poison"])
        XCTAssertEqual(viewModel.pokemon?.moves.sorted().map { $0.move.name }, ["Razor Wind", "Swords Dance"])
        XCTAssertEqual(viewModel.pokemon?.abilities.sorted().map { $0.ability.name }, ["Chlorophyll", "Overgrow"])
    }
}
