//
//  PokemonDetailSection.swift
//  Pokedex
//
//  Created by David Wee on 2/1/24.
//

import SwiftUI

struct PokemonDetailSection<Content: View, T: Identifiable & Comparable>: View {

    let title: String
    let data: [T]
    @ViewBuilder let content: (T) -> Content

    @State private var isShowing: Bool = false

    var body: some View {
        VStack {
                HStack {
                    Text(title)
                        .fontWeight(.bold)
                        .padding(.leading, 12.0)
                    Spacer()
                    Image(systemName: "arrow.right.circle")
                        .tint(Color(uiColor: .label))
                        .font(.system(size: 20.0))
                        .rotationEffect(.degrees(isShowing ? 90 : 0))
                        .animation(.default, value: isShowing)
                        .padding(.trailing, 12.0)
                }
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShowing.toggle()
                }
            }
            .modifier(CardBackground())
            .padding(.horizontal, 12.0)

            if isShowing {
                VStack {
                    ForEach(data.sorted(), id: \.id) {
                        content($0)
                            .padding(.horizontal, 5.0)
                    }
                }
                .zIndex(0)
                .transition(.opacity)
            }
    }
}
