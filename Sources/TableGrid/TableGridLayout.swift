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
        let rows = subviews
        // Rows
        for rowIndex in stride(from: 0, to: rows.count - 1, by: colCount) {
            let row = rows[rowIndex ... (rowIndex + colCount - 1)]
            if rowIndex % colCount == 0 && rowIndex != 0 {
                print("chip at \(rowIndex)")
                point.x = bounds.origin.x
                point.y += maxHeight(of: row)
                print()
            }
            print("get \(rowIndex ... (rowIndex + colCount - 1))")
            layoutAsHStack(row, point: &point)
        }
    }

    public func sizeThatFits(proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        var size: CGSize = .zero
        size.height = maxHeight(of: subviews) * CGFloat(rowCount)
        size.width = subviews.map { $0.dimensions(in: .unspecified).width }.reduce(0) { $0 + $1 }
        return size
    }

    // MARK: Layout helpers

    private func layoutAsHStack(_ views: LayoutSubviews, point: inout CGPoint) {
        for view in views {
            view.place(at: point, anchor: .topLeading, proposal: .unspecified)
            point.x += view.dimensions(in: .unspecified).width
        }
    }

    // MARK: Math helpers

    private func maxHeight(of views: LayoutSubviews) -> CGFloat {
        var maxHeight: CGFloat = 0.0
        for view in views {
            maxHeight = max(maxHeight, view.dimensions(in: .unspecified).height)
        }
        return maxHeight
    }
}
