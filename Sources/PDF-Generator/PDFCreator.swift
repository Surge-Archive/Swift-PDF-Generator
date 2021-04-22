//
//  PDFCreator.swift
//  Surge
//
//  Created by Marwan Elwaraki on 16/12/2020.
//

import UIKit

public class PDFCreator: NSObject {
    
    var pageAttributes: PDFPageAttributes = PDFPageAttributes()
    
    public var data = Data()
    var latestYPosition: (CGFloat, CGFloat) = (0, 0)
    var pageNumber: Int = 0

    public init(objects: [PDFObject], pageAttributes: PDFPageAttributes = PDFPageAttributes()) {
        super.init()
        
        self.pageAttributes = pageAttributes
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageAttributes.pageWidth, height: pageAttributes.pageHeight), format: UIGraphicsPDFRendererFormat())
        
        data = renderer.pdfData(actions: { context in
            
            newPage(context)
            
            for object in objects {
                
                switch object {
                case let label as PDFLabel:
                    label.draw()
                    setLatestYPosition(to: label.rect.maxY, alignment: .all)
                    
                case let view as PDFUIView:
                    if view.startOnNewPage {
                        newPage(context)
                    }
                    
                    view.draw()
                    setLatestYPosition(to: view.rect.maxY, alignment: view.updateYPositionOnSide)
                    
                case let table as PDFTable:
                    draw(table, in: context)
                default:
                    break
                }
                
            }
        })
    }

    func draw(_ table: PDFTable, in context: UIGraphicsPDFRendererContext) {
        
        var tableYPosition: CGFloat = 0
        
        let tableFloat = table.getAlignment(pageWidth: pageAttributes.pageWidth)
        
        var latestYPositionAtTableAlignment: CGFloat = 0
        if tableFloat == .left {
            latestYPositionAtTableAlignment = latestYPosition.0
        } else if tableFloat == .right {
            latestYPositionAtTableAlignment = latestYPosition.1
        } else {
            latestYPositionAtTableAlignment = max(latestYPosition.0, latestYPosition.1)
        }
        
        // Append 20 for spacing before table
        switch table.yPosition {
        case .auto:
            tableYPosition = latestYPositionAtTableAlignment + (table.topMargin ?? 20)
        case .newPage:
            newPage(context)
            tableYPosition = pageAttributes.pageMargin.top + (table.topMargin ?? 0)
        case .fixed(let position):
            tableYPosition = position
        }
        
        // If table is aligned to left or whole page, factor margin in its position
        var tableXPosition = table.leftMargin
        let tableAlignment = table.getAlignment(pageWidth: pageAttributes.pageWidth)
        if [PDFTableAlignment.left, PDFTableAlignment.all].contains(tableAlignment) {
            tableXPosition += pageAttributes.pageMargin.left
        }
        
        // Set table width to prespecified maxWidth,
        // or center it using its xPosition
        let tableWidth = table.maxWidth ?? (pageAttributes.pageWidth - (tableXPosition*2))
        let tableRect = CGRect(x: tableXPosition, y: tableYPosition, width: tableWidth, height: pageAttributes.pageHeight)
        drawContentInnerBordersAndText(for: table, context: context, tableRect: tableRect)
    }
}

// MARK: - Drawings
extension PDFCreator {
    
    func drawContentInnerBordersAndText(for table: PDFTable, context: UIGraphicsPDFRendererContext, tableRect: CGRect) {
        
        if table.items.isEmpty { return }
        
        var yPosition: CGFloat = tableRect.minY
        
        // Check if there's enough room for a table
        if pageHasRoomForNextTable(at: yPosition) {
            yPosition = pageAttributes.pageMargin.top
            newPage(context)
        }
        
        let drawContext = context.cgContext
        drawContext.setLineWidth(0.5)
        drawContext.saveGState()
        
        // Draw top line
        drawContext.move(to: CGPoint(x: tableRect.minX, y: yPosition))
        drawContext.addLine(to: CGPoint(x: tableRect.maxX, y: yPosition))
        drawContext.strokePath()
        
        // For each row
        for items in table.items {
            drawRow(items, tableRect: tableRect, rowYPosition: &yPosition, context: context)
        }
        
        drawContext.restoreGState()
        
        setLatestYPosition(to: yPosition, alignment: table.getAlignment(pageWidth: pageAttributes.pageWidth))
    }
    
    private func drawRow(_ items: [PDFTableItem], tableRect: CGRect, rowYPosition: inout CGFloat, context: UIGraphicsPDFRendererContext) {
        
        let drawContext = context.cgContext
        var numberOfColumns = 0
        var nextPageString: String?
        
        var largestCellHeight: CGFloat = 0
        let cellsCount = items.compactMap{ $0.horizontalScaleFactor }.reduce(0, +)
        
        let cellWidth = (tableRect.width) / CGFloat(cellsCount)
        let verticalCellPadding: CGFloat = 6
        let horizontalCellPadding: CGFloat = 4
        let paddedCellWidth = cellWidth - (horizontalCellPadding * 2)
        
        // Check if there's enough room for a row
        if pageHasRoomForNextRow(at: rowYPosition) {
            rowYPosition = pageAttributes.pageMargin.top
            newPage(context)
        }
        
        // For each cell in the row
        for (itemIndex, item) in items.enumerated() {
            
            var attributedTextArray: [NSAttributedString] = []
            
            if let itemHeader = item.header {
                let headerAttributedText = NSAttributedString(string: itemHeader, attributes: PDFConstants.cellHeaderAttributes)
                attributedTextArray.append(headerAttributedText)
            }
            
            if let itemBody = item.body {
                let bodyAttributedText = NSAttributedString(string: itemBody, attributes: PDFConstants.cellBodyAttributes)
                attributedTextArray.append((bodyAttributedText))
            }
            
            if let itemFooter = item.footer {
                let footerAttributedText = NSAttributedString(string: itemFooter, attributes: PDFConstants.cellFooterAttributes)
                attributedTextArray.append(footerAttributedText)
            }
            
            let attributedText = NSMutableAttributedString(attributedString: attributedTextArray.joined(with: "\n\n"))
            
            var cellHeight = heightForString(attributedText, width: paddedCellWidth)
            
            // If cell's content won't fit on page
            if !pageHasRoomForCellContent(cellHeight: cellHeight, yPosition: rowYPosition) {
                
                // Make a copy of the attributed string
                let copyOfAttributedText = attributedText.string
                
                // Clip current attributed string
                let index = numberOfCharactersThatFitWithinHeight(attributedText, height: pageAttributes.getHighestXBound() - rowYPosition, width: paddedCellWidth)
                attributedText.deleteCharacters(in: NSRange(location: index, length: attributedText.string.count-index))
                
                // Set the cell's height accordingly
                cellHeight = heightForString(attributedText, width: paddedCellWidth)
                
                // Save remaining string which will be drawn on a new row
                nextPageString = copyOfAttributedText.substring(start: index, includedEnd: copyOfAttributedText.count)
                
            }
            
            let cellXPosition = getCellXPosition(at: itemIndex, items: items, cellWidth: cellWidth, tableXPosition: tableRect.minX)
            
            // A cell marked as large will span the width of two cells
            let actualCellWidth = paddedCellWidth * item.horizontalScaleFactor
            
            largestCellHeight = max(largestCellHeight, cellHeight)
            let paddedCellHeight = largestCellHeight + (verticalCellPadding * 2)
            
            // Add background color if available
            // Known issue: may not color whole cell if larger one comes after it
            if let backgroundColor = item.backgroundColor {
                let backgroundRect = CGRect(x: cellXPosition, y: rowYPosition, width: cellWidth, height: paddedCellHeight)
                drawRectangle(in: backgroundRect, color: backgroundColor, drawContext: drawContext)
            }
            
            // Add text
            let textRect = CGRect(x: cellXPosition + horizontalCellPadding,
                                  y: rowYPosition + verticalCellPadding,
                                  width: actualCellWidth,
                                  height: cellHeight)
            attributedText.draw(in: textRect)
            
            // Add marker color if available
            if let markerColor = item.markerColor {
                let colorRect = CGRect(x: cellXPosition, y: rowYPosition, width: 5, height: paddedCellHeight)
                drawRectangle(in: colorRect, color: markerColor, drawContext: drawContext)
            }
        }
        
        // Adjust row's position to begin after current row
        rowYPosition += largestCellHeight
        
        // Add padding if the row isn't split over multiple pages
        if nextPageString == nil {
            rowYPosition += verticalCellPadding * 2
        }
        
        // Set the max number of columns in the table
        numberOfColumns = max(numberOfColumns, items.count)
        
        // Draw content's vertical lines
        for verticalLineIndex in 0..<numberOfColumns+1 {
            let cellXPosition = getCellXPosition(at: verticalLineIndex, items: items, cellWidth: cellWidth, tableXPosition: tableRect.minX)
            drawContext.move(to: CGPoint(x: cellXPosition, y: rowYPosition - largestCellHeight - verticalCellPadding * 2))
            drawContext.addLine(to: CGPoint(x: cellXPosition, y: rowYPosition))
            drawContext.strokePath()
        }
        
        // If the cell's content spans over into the next page, draw it
        // Otherwise, draw the cell's bottom line
        if let newSubstring = nextPageString {
            drawRow([PDFTableItem(body: newSubstring)], tableRect: tableRect, rowYPosition: &rowYPosition, context: context)
        } else {
            drawContext.move(to: CGPoint(x: tableRect.minX, y: rowYPosition))
            drawContext.addLine(to: CGPoint(x: tableRect.maxX, y: rowYPosition))
            drawContext.strokePath()
        }
    }
    
    private func drawRectangle(in frame: CGRect, color: UIColor, drawContext: CGContext) {
        drawContext.setFillColor(color.cgColor)
        drawContext.fill(frame)
    }
    
    private func getCellXPosition(at index: Int, items: [PDFTableItem], cellWidth: CGFloat, tableXPosition: CGFloat) -> CGFloat {
        let numberOfPreviousCells = items[0..<index].compactMap({$0.horizontalScaleFactor}).reduce(0, +)
        let totalWidthOfPreviousCells = numberOfPreviousCells * cellWidth
        
        let cellXPosition = totalWidthOfPreviousCells + tableXPosition
        return cellXPosition
    }
    
    private func setLatestYPosition(to value: CGFloat, alignment: PDFTableAlignment) {
        switch alignment {
        case .left:
            latestYPosition = (value, latestYPosition.1)
        case .right:
            latestYPosition = (latestYPosition.0, value)
        case .all:
            latestYPosition = (value, value)
        case .none:
            break
        }
    }
    
    // Thank you https://stackoverflow.com/a/47544250/
    private func heightForString(_ str: NSAttributedString, width: CGFloat) -> CGFloat {
        let textStorage = NSTextStorage(attributedString: str)
        
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        let textContainer = NSTextContainer(size: size)
        textContainer.lineFragmentPadding = 0.0

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        textStorage.addLayoutManager(layoutManager)
        layoutManager.glyphRange(forBoundingRect: CGRect(origin: .zero, size: size), in: textContainer)

        let rect = layoutManager.usedRect(for: textContainer)

        return rect.integral.size.height
    }
    
    func numberOfCharactersThatFitWithinHeight(_ string: NSAttributedString, height: CGFloat, width: CGFloat) -> Int {
        
        for index in (0..<string.string.count) {
            
            let substring = string.string.substring(start: 0, includedEnd: index)
            let attributedString = NSAttributedString(string: substring)
            
            if heightForString(attributedString, width: width) > height {
                return index
            }
        }
        return string.string.count
    }
    
    private func newPage(_ context: UIGraphicsPDFRendererContext) {
        latestYPosition = (pageAttributes.pageMargin.top, pageAttributes.pageMargin.top)
        context.beginPage()
        
        pageNumber += 1
        
        let pageNumberAttributedString = NSAttributedString(string: "Page \(pageNumber)", attributes: PDFConstants.tableFooterAttributes)
        
        let footerRect = CGRect(x: pageAttributes.pageWidth - 150,
                                y: pageAttributes.getHighestXBound(),
                                width: 110,
                                height: 20)
        pageNumberAttributedString.draw(in: footerRect)
    }
}

// MARK: - Bottom margins
extension PDFCreator {
    func pageHasRoomForNextTable(at yPosition: CGFloat) -> Bool {
        return yPosition > (pageAttributes.getHighestXBound() - 60)
    }
    
    func pageHasRoomForNextRow(at yPosition: CGFloat) -> Bool {
        return yPosition > (pageAttributes.getHighestXBound() - 20)
    }
    
    func pageHasRoomForCellContent(cellHeight: CGFloat, yPosition: CGFloat) -> Bool {
        return cellHeight <= (pageAttributes.getHighestXBound() - yPosition)
    }
}

// MARK: - Extensions

extension String {
    func substring(start: Int, includedEnd: Int) -> String {
        let start = String.Index(utf16Offset: start, in: self)
        let end = String.Index(utf16Offset: includedEnd, in: self)
        return String(self[start..<end])
    }
}
