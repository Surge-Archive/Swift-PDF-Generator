import XCTest
@testable import PDF_Generator

class TestPDFCreator: XCTestCase {
    
    func testTimeForNumberOfCharactersThatFitWithinHeight() {
        
        let pdfCreator: PDFCreator = PDFCreator(objects: [])
        let text = "This is repeating text.\nIt will be repeated many times."
        let repetitions = 500
        let repeatedString = String(repeating: text, count: repetitions)
        let attributedString = NSAttributedString(string: repeatedString)
        
        measure {
            _ = pdfCreator.numberOfCharactersThatFitWithinHeight(attributedString, height: 200, width: 300)
        }
    }
    
}
