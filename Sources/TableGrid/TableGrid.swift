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
        _VariadicView.Tree(TableGridLayout()) {
            content
        }
    }
}

public struct TableGridLayout: _VariadicView_UnaryViewRoot {
    @ViewBuilder
    public func body(children: _VariadicView.Children) -> some View {
        let last = children.last?.id
        VStack {
            ForEach(children) { child in
                VStack {
                    child
                    Text(child.id.description)
                }
                .background(
                    // Old way:
                    // child[TableGridRowTypeValue.self] == .row ? .blue : .clear
                    child.hasTrait(TableGridRowTypeKey.self, value: .header) ? .blue : .clear
                )

                if child.id != last {
                    Divider()
                }
            }
        }
    }
}
