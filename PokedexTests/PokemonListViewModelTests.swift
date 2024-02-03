//
//  PokemonListViewModelTests.swift
//  PokedexTests
//
//  Created by David Wee on 2/2/24.
//

import Combine
import Foundation
import XCTest
@testable import Pokedex

final class PokemonListViewModelTests: XCTestCase {

    var viewModel: PokemonListViewModel!
    var mockNetwork: NetworkMock!

    override func setUp() {
        super.setUp()
        mockNetwork = NetworkMock()
        viewModel = PokemonListViewModel(network: mockNetwork)
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockNetwork = nil
    }

    private func waitForListLoad() {
        let expectaion = expectation(description: "Wait for pokemon response")
        var cancellable: AnyCancellable?

        cancellable = viewModel.$pokemonList.dropFirst().sink { _ in
            expectaion.fulfill()
            cancellable = nil
        }
        viewModel.loadPokemon()

        waitForExpectations(timeout: 2.0)
    }

    func testSuccessfullFetch() {
        // On Successful load
        waitForListLoad()
        // List should not be empty
        XCTAssertFalse(viewModel.pokemonList.isEmpty)
    }

    func testEmptyOrInvalidFetch() {
        // When empty list is loaded
        mockNetwork.mock(endpoint: PokemonEndpoint.getList, with: "pokemon_list_empty")
        waitForListLoad()
        // Pokemon List should be empty
        XCTAssertTrue(viewModel.pokemonList.isEmpty)

        // When list is malformed
        mockNetwork.mock(endpoint: PokemonEndpoint.getList, with: "pokemon_list_malformed")
        waitForListLoad()
        // Pokemon List should be empty
        XCTAssertTrue(viewModel.pokemonList.isEmpty)
    }

    func testListSearch() {
        waitForListLoad()
        // With no Search String applied

        // Filtered Pokemon should be the whole list
        XCTAssertEqual(viewModel.filteredPokemon(), viewModel.pokemonList)

        // When a search string is applies
        viewModel.searchText = "charmander"

        // Only that search should appear
        XCTAssertEqual(viewModel.filteredPokemon().count, 1)
        XCTAssertEqual(viewModel.filteredPokemon().first?.name, "Charmander")

        // When the word contains a different variation of a character
        viewModel.searchText = "Chǎrmander"

        // Search should still work
        XCTAssertEqual(viewModel.filteredPokemon().count, 1)
        XCTAssertEqual(viewModel.filteredPokemon().first?.name, "Charmander")
    }
}
