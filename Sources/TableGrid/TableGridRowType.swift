//
//  TableGridRowType.swift
//  GridLayout
//
//  Created by Peter Kos on 5/25/24.
//

import SwiftUI

private struct TableGridRowTypeModifier<Trait> where Trait: _ViewTraitKey {
    public let value: Trait.Value
}

internal struct TableGridRowTypeKey: _ViewTraitKey {
    static var defaultValue: TableGridRowType = .header
}

internal enum TableGridRowType {
    case header
    case row
}
