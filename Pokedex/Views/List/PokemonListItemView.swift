//
//  PokemonListItemView.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonListItemView: View {
    
    let pokemon: PokemonListItem
    let animation: Namespace.ID?
    let backgroundColor: Color

    @State var heroFontLarge = false
    
    var body: some View {
        VStack {
            WebImage(url: PokemonEndpoint.getImage(id: pokemon.id).url)
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .if(animation != nil) { view in
                        view
                        .matchedGeometryEffect(id: "image-\(pokemon.id)", in: animation!)
                        .transition(.scale(scale: 1.0))
                }
                .frame(width: 75.0, height: 75.0)
            
            Spacer()
            
            Text(pokemon.name)
                .if(animation != nil) { view in
                    view
                        .animatableFont(name: "San Francisco", size: heroFontLarge ? 32.0 : 16.0)
                        .matchedGeometryEffect(id: "name-\(pokemon.id)", in: animation!)
                        .onAppear {
                            withAnimation {
                                heroFontLarge = false
                            }
                        }
                        .transition(.scale(scale: 1))
                }

        }
        .padding()
        .modifier(CardBackground(color: backgroundColor, geometryID: "bg-\(pokemon.id)", namespaceID: animation))
    }
}
