//
//  PokemonListView.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonListView: View {
    @Namespace var animation

    @ObservedObject var viewModel = PokemonListViewModel()
    @State private var selectedPokemon: PokemonListItem?
    @State private var isPresented: Bool = false

    var body: some View {

        NavigationStack {
            Group {
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ActivityIndicator(.constant(true), style: .large)
                        Spacer()
                    }
                } else if !viewModel.pokemonList.isEmpty {
                    if viewModel.filteredPokemon().isEmpty {
                        Text(Strings.List.noneFound(viewModel.searchText))
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 15.0),
                                GridItem(.flexible(), spacing: 15.0)
                            ], spacing: 25.0) {
                                ForEach(viewModel.filteredPokemon(), id: \.id) { pokemon in

                                    if selectedPokemon?.id == pokemon.id, isPresented {
                                        Color.clear
                                    } else {
                                        PokemonListItemView(pokemon: pokemon, animation: animation,backgroundColor: Color(uiColor: .secondarySystemBackground))
                                            .onTapGesture {
                                                guard selectedPokemon == nil else { return }
                                                withAnimation {
                                                    self.selectedPokemon = pokemon
                                                    self.isPresented.toggle()
                                                }
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal, 12.0)
                        }
                    }
                } else {
                    Button(action: {
                        viewModel.loadPokemon()
                    }, label: {
                        Text(Strings.List.emptyStateText)
                    })
                }
            }
            .navigationTitle(Strings.List.title)
            .searchable(text: $viewModel.searchText)
        }
        .overlay {
            if let selectedPokemon, isPresented {
                PokemonDetailView(viewModel: PokemonDetailViewModel(pokemonListItem: selectedPokemon), isPresented: $isPresented, animation: animation)
                    .background {
                        Color(UIColor.systemBackground)
                            .ignoresSafeArea()
                    }
                    .onDisappear {
                        self.selectedPokemon = nil
                    }
            }
        }
    }
}

#Preview {
    PokemonListView()
}
