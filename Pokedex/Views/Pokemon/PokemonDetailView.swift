//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import SwiftUI
import SDWebImageSwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct PokemonDetailView: View {

    @ObservedObject var viewModel: PokemonDetailViewModel
    @Binding var isPresented: Bool
    let animation: Namespace.ID
    @State var heroFontLarge = false
    @State var titleOpacity: Double = 0.0
    @State var showDetails: Bool = false
    @State var scrollPosition: Int?

    var body: some View {
        VStack {
            closeButton

            ScrollView {
                VStack {
                    headerView
                        .background(
                             GeometryReader { proxy in
                               Color.clear
                                 .preference(
                                   key: OffsetPreferenceKey.self,
                                   value: proxy.frame(in: .named("frameLayer")).minY
                                 )
                             }
                           )

                        sections
                }
                .animation(.easeInOut, value: viewModel.isLoading)
                .animation(.easeInOut, value: showDetails)
                .animation(.easeInOut, value: viewModel.pokemon)
            }
            .coordinateSpace(name: "frameLayer")
            .onPreferenceChange(OffsetPreferenceKey.self, perform: { value in
                let opacity = value < -230 ? 1.0 : 0.0
                if titleOpacity != opacity {
                    withAnimation {
                        titleOpacity = opacity
                    }
                }
            })
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showDetails = true
            }
        }
        .background(
            Color(UIColor.systemBackground)
                .matchedGeometryEffect(id: "bg-\(viewModel.pokemonId)", in: animation)
        )
    }

    // MARK: - Header
    @ViewBuilder
    private var headerView: some View {
        WebImage(url: PokemonEndpoint.getImage(id: viewModel.pokemonId).url)
            .resizable()
            .indicator(.activity)
            .scaledToFit()
            .matchedGeometryEffect(id: "image-\(viewModel.pokemonId)", in: animation)
            .transition(.scale(scale: 1.0))
            .frame(maxHeight: 200)

        Text(viewModel.pokemonName)
            .animatableFont(name: "San Francisco", size: heroFontLarge ? 32.0: 16)
            .matchedGeometryEffect(id: "name-\(viewModel.pokemonId)", in: animation)
            .minimumScaleFactor(0.1)
            .onAppear {
                withAnimation {
                    heroFontLarge = true
                }
            }
            .transition(.scale(scale: 1))
    }

    // MARK: - Sections

    @ViewBuilder
    private var sections: some View {

        if viewModel.isLoading || !showDetails {
            VStack {
                Spacer()
                    .frame(height: 100.0)
                ActivityIndicator(.constant(true), style: .large)
            }
        } else {
            
            if let pokemon = viewModel.pokemon {
                LazyVStack {
                    VStack {
                        HStack {
                            KeyValueTextView(key: Strings.Detail.height, value: viewModel.heightString)
                            KeyValueTextView(key: Strings.Detail.weight, value: viewModel.weightString)
                        }
                        KeyValueTextView(key: Strings.Detail.baseExp, value: String(pokemon.baseExperience))
                        
                        if let species = viewModel.species {
                            KeyValueTextView(key: Strings.Detail.happiness, value: String(species.happiness))
                            KeyValueTextView(key: Strings.Detail.captureRate, value: String(species.happiness))
                        }
                    }
                    .padding()
                    .modifier(CardBackground())
                    .padding(.horizontal, 12.0)
                    
                    if let evolutions = viewModel.evolutions?.evolutions, !evolutions.isEmpty {
                        PokemonDetailSection(title: Strings.Detail.evolutions, data: evolutions) {
                            PokemonListItemView(pokemon: $0, animation: nil, backgroundColor: Color(uiColor: .tertiarySystemBackground))
                                .padding(.horizontal)
                        }
                    }
                    
                    PokemonDetailSection(title: Strings.Detail.stats, data: pokemon.stats) {
                        PokemonStatsView(stat: $0)
                    }

                    PokemonDetailSection(title: Strings.Detail.types, data: pokemon.types) {
                        SmallTextBackgroundView(text: $0.type.name)
                    }
                    
                    PokemonDetailSection(title: Strings.Detail.moves, data: pokemon.moves) {
                        SmallTextBackgroundView(text: $0.move.name)
                    }
                    
                    PokemonDetailSection(title: Strings.Detail.abilities, data: pokemon.abilities) {
                        SmallTextBackgroundView(text: $0.ability.name)
                    }
                }
                .transition(.slide)
            } else {
                Button(action: {
                    viewModel.reload()
                }, label: { Text(Strings.Detail.reloadError) })
            }
        }
    }

    // MARK: - Title Header
    @ViewBuilder
    private var closeButton: some View {
        ZStack {
            HStack {
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .tint(Color(uiColor: .label))
                        .font(.system(size: 20.0))
                })
                Spacer()
            }
            .padding(.leading, 15.0)

            Text(viewModel.pokemonName)
                .font(.title)
                .opacity(titleOpacity)
        }
        .background(Color(uiColor: .systemBackground)
            .ignoresSafeArea(edges: .top)
        )
    }
}

