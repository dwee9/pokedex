//
//  KeyedDecodingContainer+.swift
//  Pokedex
//
//  Created by David Wee on 2/2/24.
//

import Foundation

extension KeyedDecodingContainer {

    /// Decodes a given URLString into an ID
    /// - Parameter key: The key to decode
    /// - returns: The ID as an `Int`
    func decodeURLToID(forKey key: K) throws -> Int {
        guard let idString = URL(string: try self.decode(String.self, forKey: key))?.lastPathComponent, let id = Int(idString) else {
            throw DecodingError.valueNotFound(Int.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: ""))
        }
        return id
    }
}
