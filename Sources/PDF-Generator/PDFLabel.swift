//
//  PDFLabel.swift
//  Surge
//
//  Created by Marwan Elwaraki on 16/12/2020.
//

import UIKit

public struct PDFLabel: PDFObject {
    var text: NSString
    var rect: CGRect
    var attributes: [NSMutableAttributedString.Key: NSObject]
    
    func draw() {
        text.draw(in: rect, withAttributes: attributes)
    }
}
