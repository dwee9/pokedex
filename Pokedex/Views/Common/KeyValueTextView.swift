//
//  KeyValueTextView.swift
//  Pokedex
//
//  Created by David Wee on 2/1/24.
//

import SwiftUI

struct KeyValueTextView: View {
    let key: String
    let value: String

    var body: some View {
        HStack {
            Text("\(key):")
                .fontWeight(.medium)
            Text(value)
        }
    }
}
