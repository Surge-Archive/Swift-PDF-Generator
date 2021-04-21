//
//  PDFConstants.swift
//  Surge
//
//  Created by Marwan Elwaraki on 17/12/2020.
//

import UIKit

class PDFConstants {
    
    typealias PDFTextAttributes = [NSMutableAttributedString.Key: NSObject]
    
    static func attributes(withFontSize fontSize: CGFloat, fontWeight: UIFont.Weight, paragraphAlignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> PDFTextAttributes {
        
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = paragraphAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        return [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
    }
    
    static var h1Attributes: PDFTextAttributes = attributes(withFontSize: 14, fontWeight: .medium)
    static var h2Attributes: PDFTextAttributes = attributes(withFontSize: 11, fontWeight: .medium)
    static var cellHeaderAttributes: PDFTextAttributes = attributes(withFontSize: 8, fontWeight: .semibold)
    static var cellBodyAttributes: PDFTextAttributes = attributes(withFontSize: 8, fontWeight: .regular)
    static var cellFooterAttributes: PDFTextAttributes = attributes(withFontSize: 6, fontWeight: .light)
    static var tableFooterAttributes: PDFTextAttributes = attributes(withFontSize: 7, fontWeight: .medium, paragraphAlignment: .right)
}
