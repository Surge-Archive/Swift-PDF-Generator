//
//  PDFConstants.swift
//  Surge
//
//  Created by Marwan Elwaraki on 17/12/2020.
//

import UIKit

public class PDFConstants {
    
    public typealias PDFTextAttributes = [NSMutableAttributedString.Key: NSObject]
    
    public static func attributes(withFontSize fontSize: CGFloat, fontWeight: UIFont.Weight, paragraphAlignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> PDFTextAttributes {
        
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = paragraphAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        return [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
    }
    
    public static var h1Attributes: PDFTextAttributes = attributes(withFontSize: 14, fontWeight: .medium)
    public static var h2Attributes: PDFTextAttributes = attributes(withFontSize: 11, fontWeight: .medium)
    public static var cellHeaderAttributes: PDFTextAttributes = attributes(withFontSize: 8, fontWeight: .semibold)
    public static var cellBodyAttributes: PDFTextAttributes = attributes(withFontSize: 8, fontWeight: .regular)
    public static var cellFooterAttributes: PDFTextAttributes = attributes(withFontSize: 6, fontWeight: .light)
    public static var tableFooterAttributes: PDFTextAttributes = attributes(withFontSize: 7, fontWeight: .medium, paragraphAlignment: .right)
}
