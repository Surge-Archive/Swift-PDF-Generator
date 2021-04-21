//
//  PDFTableItem.swift
//  Surge
//
//  Created by Marwan Elwaraki on 21/12/2020.
//

import Foundation
import UIKit.UIColor

public struct PDFTableItem: Equatable {
    var header: String?
    var body: String?
    var footer: String?
    var markerColor: UIColor?
    var backgroundColor: UIColor?
    var isLargeCell: Bool = false
    var horizontalScaleFactor: CGFloat { return isLargeCell ? 1.5 : 1 }
    
    public init(header: String) {
        self.header = header
    }

    public init(body numericalValue: Int64?) {
        if let numericalValue = numericalValue {
            body = String(describing: numericalValue)
        }
    }

    public init(header: String? = nil, body: String? = nil, footer: String? = nil, largeCell: Bool = false, markerColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.header = header
        self.body = body
        self.footer = footer
        self.isLargeCell = largeCell
        self.markerColor = markerColor
        self.backgroundColor = backgroundColor
    }
}
