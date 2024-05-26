//
//  View+Extensions.swift
//  GridLayout
//
//  Created by Peter Kos on 5/25/24.
//

import SwiftUI

extension View {
    /// Convenience for setting a `_ViewTraitKey`
    func withTrait<Trait, Value>(_: Trait.Type, value: Value) -> some View
        where Trait: _ViewTraitKey, Value == Trait.Value
    {
        _trait(Trait.self, value)
    }
}

extension _VariadicView.Children.Element {
    /// Check if a `Trait.Value` is set on a variadic view's child.
    func hasTrait<Trait, Value>(_: Trait.Type, value: Value) -> Bool
        where Trait: _ViewTraitKey, Value == Trait.Value, Value: Equatable
    {
        self[Trait.self] == value
    }
}
