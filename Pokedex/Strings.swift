//
//  Strings.swift
//  Pokedex
//
//  Created by David Wee on 2/2/24.
//

import Foundation

enum Strings {

    enum List {
        static let emptyStateText = "No Pokemon found, tap to reload"
        static func noneFound(_ search: String) -> String {
            "No Pokemon found for \"\(search)\""
        }
        static let title = "Pokemon"
    }

    enum Detail {
        static var stats = "Stats"
        static var base = "Base"
        static var effort = "Effort"
        static var height = "Height"
        static var heightValue = "%.1f in"
        static var weight = "Weight"
        static var weightValue = "%.1f lbs"
        static var baseExp = "Base Exp"
        static var happiness = "Happiness"
        static var captureRate = "Capture Rate"
        static var evolutions = "Evolutions"
        static var types = "Types"
        static var moves = "Moves"
        static var abilities = "Abilites"
        static var reloadError = "Something went wrong, tap to try again"
    }
}
