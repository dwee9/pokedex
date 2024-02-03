//
//  PokemonStatsView.swift
//  Pokedex
//
//  Created by David Wee on 2/2/24.
//

import SwiftUI

struct PokemonStatsView: View {
    let stat: PokemonStat

    var body: some View {
        VStack(alignment: .leading){
            Text(stat.name)
                .fontWeight(.bold)
            HStack {
                KeyValueTextView(key: Strings.Detail.base, value: String(stat.base))
                KeyValueTextView(key: Strings.Detail.effort, value: String(stat.effort))
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5.0)
        .modifier(CardBackground(color: Color(uiColor: .tertiarySystemBackground)))
        .padding(.horizontal)
    }
}

