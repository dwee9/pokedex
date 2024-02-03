//
//  AnimatableCustomFontModifier.swift
//  Pokedex
//
//  Created by David Wee on 2/1/24.
//

import SwiftUI

/// A `ViewModifier` that helps with animaiting a change to the size of a Text view
///
/// ```
///View..modifier(AnimatableCustomFontModifier(name: name, size: size))
/// ```
struct AnimatableCustomFontModifier: ViewModifier, Animatable {
    var name: String
    var size: Double

    var animatableData: Double {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(name, size: size))
            .frame(maxWidth: .infinity)
    }
}

extension View {
    /// Applies a `AnimatableCustomFontModifier` to the View
    ///
    /// ```
    ///.modifier(AnimatableCustomFontModifier(name: name, size: size))
    /// ```
    func animatableFont(name: String, size: Double) -> some View {
        self.modifier(AnimatableCustomFontModifier(name: name, size: size))
    }
}
