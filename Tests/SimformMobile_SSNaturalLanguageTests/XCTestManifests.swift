import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SimformMobile_SSNaturalLanguageTests.allTests),
    ]
}
#endif
