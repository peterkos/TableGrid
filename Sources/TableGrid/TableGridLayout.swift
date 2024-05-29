//
//  TableGridLayout.swift
//
//
//  Created by Peter Kos on 5/26/24.
//

import SwiftUI

/// Assumes non-jagged layout (i.e., `rowCount == colCount`)
public struct TableGridLayout: Layout {
    typealias ColIndex = Int
    typealias RowIndex = Int

    var rowCount: Int
    var colCount: Int {
        rowCount
    }

    /// Spacing between columns
    var horizontalSpacing: CGFloat = 0.0

    /// Spacing between rows
    var verticalSpacing: CGFloat = 0

    public func placeSubviews(
        in bounds: CGRect,
        proposal _: ProposedViewSize,
        subviews: Subviews,
        cache _: inout ()
    ) {
        var point = bounds.origin
        let rows = chunkRows(subviews, size: rowCount)
        let cols = chunkCols(subviews, size: colCount)
        let rowHeights = calcRowHeights(rows: rows)
        let colWidths = calcColumnWidths(cols: cols)

        for (rowIndex, row) in rows.enumerated() {
            layoutAsHStack(row, point: &point, colWidths: colWidths)
            point.x = bounds.origin.x
            point.y += rowHeights[rowIndex] ?? 0
        }
    }

    public func sizeThatFits(proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        var size: CGSize = .zero
        let rowWidths = calcRowHeights(rows: chunkRows(subviews, size: rowCount))
        size.height = rowWidths.reduce(0) { result, width in
            result + width
        }

        let colWidths = calcColumnWidths(cols: chunkCols(subviews, size: colCount))
        size.width = colWidths.reduce(0) { result, width in
            result + width
        }
        return size
    }

    // MARK: - Layout

    private func layoutAsHStack(_ views: [LayoutSubview], point: inout CGPoint, colWidths: [CGFloat]) {
        for (i, view) in views.enumerated() {
            view.place(at: point, anchor: .topLeading, proposal: .unspecified)

            // Do we not need to account for the view width?
            if let colWidth = colWidths[safe: i] {
                point.x += colWidth
            }
        }
    }
}

extension TableGridLayout {
    // MARK: Math helpers

    private func maxHeight(of views: [LayoutSubview]) -> CGFloat {
        var maxHeight: CGFloat = 0.0
        for view in views {
            maxHeight = max(maxHeight, view.dimensions(in: .unspecified).height)
        }
        return maxHeight
    }

    // TODO: figure out how to do type magic to not need to overload `maxHeight`
    private func maxHeight(of views: LayoutSubviews) -> CGFloat {
        var maxHeight: CGFloat = 0.0
        for view in views {
            maxHeight = max(maxHeight, view.dimensions(in: .unspecified).height)
        }
        return maxHeight
    }

    private func maxWidth(of views: [LayoutSubview]) -> CGFloat {
        var maxWidth: CGFloat = 0.0
        for view in views {
            maxWidth = max(maxWidth, view.dimensions(in: .unspecified).width)
        }
        return maxWidth
    }

    /// Note: `[LayoutSubviews] ~= [[LayoutSubview]]`
    private func chunkRows(_ elements: LayoutSubviews, size: Int) -> [[LayoutSubview]] {
        stride(from: 0, to: elements.count - 1, by: size).map { i in
            Array(elements[i ... (i + size - 1)])
        }
    }

    private func chunkCols(_ elements: LayoutSubviews, size _: Int) -> [[LayoutSubview]] {
        // Putting first value as blank until filled to avoid optional gymnastics
        guard let first = elements.first else {
            return [[]]
        }
        var cols = Array(repeating: first, count: rowCount)
        var colMajor: [[LayoutSubview]] = Array(repeating: cols, count: colCount)
        for colIndex in 0 ..< colCount {
            for rowIndex in 0 ..< rowCount {
                if let col = elements[safe: (rowIndex * colCount) + colIndex] {
                    colMajor[colIndex][rowIndex] = col
                } else {
                    print("No subview for chunkCols at (c, r) (\(colIndex), \(rowIndex))")
                }
            }
        }
        return colMajor
    }

    /// For row index `r`, `rowHeights[r] == maxHeight(row[r])`
    private func calcRowHeights(rows: [[LayoutSubview]]) -> [CGFloat] {
        var rowHeights: [CGFloat] = Array(repeating: 0.0, count: rowCount)
        for (r, row) in rows.dropLast().enumerated() {
            rowHeights[r] = maxHeight(of: row) + verticalSpacing
        }
        if let lastRow = rows.last {
            rowHeights.append(maxHeight(of: lastRow))
        }
        return rowHeights
    }

    /// For column index `c`, `columnWidths[c] == maxWidth(column[c])`
    private func calcColumnWidths(cols: [[LayoutSubview]]) -> [CGFloat] {
        var colWidths: [CGFloat] = Array(repeating: 0.0, count: colCount)
        for (c, col) in cols.enumerated() {
            colWidths[c] = maxWidth(of: col) + horizontalSpacing
        }
        return colWidths
    }
}
