//
//  PDFPageAttributes.swift
//  Surge
//
//  Created by Marwan Elwaraki on 12/01/2021.
//  Copyright © 2021 Surge. All rights reserved.
//

import UIKit

public struct PDFPageAttributes {
    
    // Default to A4
    public var pageWidth: CGFloat
    public var pageHeight: CGFloat
    public var pageMargin: UIEdgeInsets
    
    public init(pageWidth: CGFloat = 8.25 * 72.0, pageHeight: CGFloat = 11.75 * 72.0, pageMargin: UIEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)) {
        self.pageWidth = pageWidth
        self.pageHeight = pageHeight
        self.pageMargin = pageMargin
    }
    
    func getHighestXBound() -> CGFloat {
        return pageHeight - pageMargin.bottom
    }
}
