//
//  Collection+Extensions.swift
//  NewProject
//
//  Created by Peter Kos on 5/29/24.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
