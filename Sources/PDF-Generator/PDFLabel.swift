//
//  PDFLabel.swift
//  Surge
//
//  Created by Marwan Elwaraki on 16/12/2020.
//

import UIKit

public struct PDFLabel: PDFObject {
    public var text: NSString
    public var rect: CGRect
    public var attributes: [NSMutableAttributedString.Key: NSObject]
    
    public init(text: NSString, rect: CGRect, attributes: [NSAttributedString.Key : NSObject]) {
        self.text = text
        self.rect = rect
        self.attributes = attributes
    }
    
    public func draw() {
        text.draw(in: rect, withAttributes: attributes)
    }
}
