//
//  Traits.swift
//  GridLayout
//
//  Created by Peter Kos on 5/25/24.
//

import SwiftUI

struct TableGridRowTypeKey: _ViewTraitKey {
    static var defaultValue: TableGridRowType = .header
}

enum TableGridRowType {
    case header
    case row
}

struct CellCount: LayoutValueKey {
    static var defaultValue: Int = 0
}

// Should be useful
struct CellSize: _ViewTraitKey {
    static var defaultValue: CGSize = .zero
}
