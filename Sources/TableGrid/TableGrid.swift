//
//  TableGrid.swift
//  GridLayout
//
//  Created by Peter Kos on 5/23/24.
//

import SwiftUI

public struct TableGrid<Content: View>: View {
    public var content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        _VariadicView.Tree(TableGridLayoutRoot()) {
            content
        }
    }
}

public struct TableGridLayoutRoot: _VariadicView_UnaryViewRoot {
    @ViewBuilder
    public func body(children: _VariadicView.Children) -> some View {
        // FIXME: Make fully dynamic
        TableGridLayout(
            rowCount: 3,
            horizontalSpacing: 20,
            verticalSpacing: 10
        ) {
            children
        }
    }
}
