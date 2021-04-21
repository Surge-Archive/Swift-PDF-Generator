import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PDF_GeneratorTests.allTests),
    ]
}
#endif
