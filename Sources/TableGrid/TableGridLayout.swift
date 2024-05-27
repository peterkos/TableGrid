//
//  TableGridLayout.swift
//
//
//  Created by Peter Kos on 5/26/24.
//

import SwiftUI

/// Assumes non-jagged layout (i.e., `rowCount == colCount`)
public struct TableGridLayout: Layout {
    var rowCount: Int
    var colCount: Int {
        rowCount
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal _: ProposedViewSize,
        subviews: Subviews,
        cache _: inout ()
    ) {
        var point = bounds.origin
        let rows = chunk(subviews, size: colCount)

        for row in rows {
            layoutAsHStack(row, point: &point)
            point.x = bounds.origin.x
            point.y += maxHeight(of: row)
        }
    }

    public func sizeThatFits(proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        var size: CGSize = .zero
        size.height = maxHeight(of: subviews) * CGFloat(rowCount)
        size.width = subviews.map { $0.dimensions(in: .unspecified).width }.reduce(0) { $0 + $1 }
        return size
    }

    // MARK: Layout

    private func layoutAsHStack(_ views: [LayoutSubview], point: inout CGPoint) {
        for view in views {
            view.place(at: point, anchor: .topLeading, proposal: .unspecified)
            point.x += view.dimensions(in: .unspecified).width
        }
    }

    // MARK: Math helpers

    private func maxHeight(of views: [LayoutSubview]) -> CGFloat {
        var maxHeight: CGFloat = 0.0
        for view in views {
            maxHeight = max(maxHeight, view.dimensions(in: .unspecified).height)
        }
        return maxHeight
    }

    // TODO: figure out how to do type magic to make above work
    private func maxHeight(of views: LayoutSubviews) -> CGFloat {
        var maxHeight: CGFloat = 0.0
        for view in views {
            maxHeight = max(maxHeight, view.dimensions(in: .unspecified).height)
        }
        return maxHeight
    }

    /// Note: `[LayoutSubviews] ~= [[LayoutSubview]]`
    private func chunk(_ elements: LayoutSubviews, size: Int) -> [[LayoutSubview]] {
        stride(from: 0, to: elements.count - 1, by: size).map { i in
            Array(elements[i ... (i + size - 1)])
        }
    }
}
