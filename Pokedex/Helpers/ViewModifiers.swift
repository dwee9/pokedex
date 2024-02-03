//
//  ViewModifiers.swift
//  Pokedex
//
//  Created by David Wee on 2/1/24.
//

import Foundation
import SwiftUI

/// A `ViewModifier` that puts the view inside a Card Background
///
/// - Parameters:
///    - color: The background color
///    - geometryID: The name for any matchesGeometry associated with the view
///    - namespaceID: The `Namespace.ID`associated with the view
struct CardBackground: ViewModifier {
    let color: Color
    let geometryID: String?
    let namespaceID: Namespace.ID?

    init(color: Color = Color(UIColor.secondarySystemBackground), geometryID: String? = nil, namespaceID: Namespace.ID? = nil) {
        self.color = color
        self.geometryID = geometryID
        self.namespaceID = namespaceID
    }

    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(color)
                .shadow(radius: 10)
                .if((geometryID != nil && namespaceID != nil)) { view in
                    view.matchedGeometryEffect(id: geometryID!, in: namespaceID!)
                }
            content
        }
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
