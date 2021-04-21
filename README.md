# Swift PDF Generator

A lightweight PDF generator built in Swift. You can install it using Swift Package Manager. 

## Create a label
```swift
PDFLabel(text: "My text", rect: CGRect(x: 90, y: 40, width: 200, height: 30), 
  attributes: PDFConstants.h1Attributes)
```

## Create a table
```swift
PDFTable(leftMargin: CGFloat, yPosition: PDFTableStartingYPosition,
  items: [[PDFTableItem]], maxWidth: CGFloat?, topMargin: CGFloat)
```
A table takes in several parameters:
* `leftMargin`: distance from the left of the page (0 by default)
* `yPosition`: how to vertically align the table. This can be: `auto` (after the previous table), `newPage` (at the start of the next page) or `fixed(CGFloat)` which specifies a Y Position.
* `items`: the cells in the table. This is a 2d Array with the outer array representing columns and the inner array representing rows. Every `PDFTableItem` is one cell. `[PDFTableItem]` represents a row of cells in a table.
* `maxWidth`: the maximum width of the table. (defaults to the maximum width of the page minus the horizontal margins.
* `topMargin`: a margin on top of the table to allow spacing between objects on the PDF (20 by default)

## Create the PDF
The `PDFCreator` takes `[PDFObject]` as an input. Labels and tables are classified as PDF objects.
```swift
let pdfCreator = PDFCreator(objects: pdfObjects)
let pdfDocument = PDFDocument(data: pdfCreator.data) // requires import PDFKit
```
