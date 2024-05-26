//
//  TableGridViews.swift
//  GridLayout
//
//  Created by Peter Kos on 5/23/24.
//

import SwiftUI

public struct TableGridHeader<Content: View>: View {
    public var content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
//        _VariadicView.Tree(TableGridHeaderTree()) {
        content
//        }
            .withTrait(TableGridRowTypeKey.self, value: .header)
    }

    struct TableGridHeaderTree: _VariadicView_MultiViewRoot {
        @ViewBuilder
        func body(children: _VariadicView.Children) -> some View {
            HStack {
                children
            }
            .layoutValue(key: CellCount.self, value: children.count)
        }
    }
}

public struct TableGridRow<Content: View>: View {
    @ViewBuilder var content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
//        _VariadicView.Tree(TableGridRowTree()) {
        content
//        }
            .withTrait(TableGridRowTypeKey.self, value: .row)
    }

    struct TableGridRowTree: _VariadicView_MultiViewRoot {
        @ViewBuilder
        func body(children: _VariadicView.Children) -> some View {
            HStack {
                ForEach(children) { child in
                    child
                }
            }
            .layoutValue(key: CellCount.self, value: children.count)
        }
    }
}
