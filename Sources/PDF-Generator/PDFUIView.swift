//
//  PDFUIView.swift
//  Surge
//
//  Created by Marwan Elwaraki on 04/01/2021.
//

import UIKit

public struct PDFUIView: PDFObject {
    
    var rect: CGRect
    var startOnNewPage: Bool = false
    var updateYPositionOnSide: PDFTableAlignment = .all
    let image: UIImage
    
    public init(view: UIView, startOnNewPage: Bool = false, rect: CGRect, updateYPositionOnSide: PDFTableAlignment = .all) {
        self.rect = rect
        self.startOnNewPage = startOnNewPage
        self.image = view.asImage()
        self.updateYPositionOnSide = updateYPositionOnSide
    }
    
    public func draw() {
        image.draw(in: rect)
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
