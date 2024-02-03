//
//  SmallTextBackgroundView.swift
//  Pokedex
//
//  Created by David Wee on 2/2/24.
//

import SwiftUI

struct SmallTextBackgroundView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding(.vertical, 4.0)
            .modifier(CardBackground(color: Color(uiColor: .tertiarySystemBackground)))
            .padding(.horizontal)
    }
}
