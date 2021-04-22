//
//  PDFTable.swift
//  Surge
//
//  Created by Marwan Elwaraki on 16/12/2020.
//

import UIKit

public struct PDFTable: PDFObject, Equatable {
    var leftMargin: CGFloat
    var yPosition: PDFTableStartingYPosition
    var items: [[PDFTableItem]]
    var maxWidth: CGFloat?
    var topMargin: CGFloat?
    
    public init(leftMargin: CGFloat = 0, yPosition: PDFTableStartingYPosition = .auto, items: [[PDFTableItem]], maxWidth: CGFloat? = nil, topMargin: CGFloat? = nil) {
        self.leftMargin = leftMargin
        self.yPosition = yPosition
        self.items = items
        self.maxWidth = maxWidth
        self.topMargin = topMargin
    }
    
    func getAlignment(pageWidth: CGFloat) -> PDFTableAlignment {
        if maxWidth == nil {
            return .all
        } else {
            return leftMargin < pageWidth/2 ? .left : .right
        }
    }
    
    public static func == (lhs: PDFTable, rhs: PDFTable) -> Bool {
        return lhs.items == rhs.items
    }
}

public indirect enum PDFTableStartingYPosition {
    case auto
    case newPage
    case fixed(_ position: CGFloat)
}

public enum PDFTableAlignment {
    case left
    case right
    case all
    case none
}
