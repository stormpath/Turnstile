import XCTest
@testable import Turnstile

class TurnstileTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Turnstile().text, "Hello, World!")
    }


    static var allTests : [(String, (TurnstileTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
