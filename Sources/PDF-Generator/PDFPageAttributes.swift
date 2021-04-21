//
//  PDFPageAttributes.swift
//  GNAAS
//
//  Created by Marwan Elwaraki on 12/01/2021.
//  Copyright © 2021 Surge. All rights reserved.
//

import UIKit

struct PDFPageAttributes {
    
    // Default to A4
    var pageWidth: CGFloat = 8.25 * 72.0 // 594
    var pageHeight: CGFloat = 11.75 * 72.0 // 846
    
    var pageMargin = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
    
    func getHighestXBound() -> CGFloat {
        return pageHeight - pageMargin.bottom
    }
}
