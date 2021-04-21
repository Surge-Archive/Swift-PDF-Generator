//
//  PDFTable.swift
//  Surge
//
//  Created by Marwan Elwaraki on 16/12/2020.
//

import UIKit

struct PDFTable: PDFObject, Equatable {
    var leftMargin: CGFloat = 0
    var yPosition: PDFTableStartingYPosition = .auto
    var items: [[PDFTableItem]]
    var maxWidth: CGFloat?
    var topMargin: CGFloat = 20
    
    func getAlignment(pageWidth: CGFloat) -> PDFTableAlignment {
        if maxWidth == nil {
            return .all
        } else {
            return leftMargin < pageWidth/2 ? .left : .right
        }
    }
    
    static func == (lhs: PDFTable, rhs: PDFTable) -> Bool {
        return lhs.items == rhs.items
    }
}

indirect enum PDFTableStartingYPosition {
    case auto
    case newPage
    case fixed(_ position: CGFloat)
}

enum PDFTableAlignment {
    case left
    case right
    case all
    case none
}
