import XCTest
@testable import Turnstile

class TurnstileTests: XCTestCase {
    var turnstile: Turnstile!
    var sessionManager: SessionManager!
    var realm: Realm!
    
    override func setUp() {
        sessionManager = MemorySessionManager()
        realm = MemoryRealm()
        turnstile = Turnstile(sessionManager: sessionManager, realm: realm)
    }
    
    func testThatTurnstileReturnsUniqueSubjects() {
        let subject = turnstile.createSubject()
        let subject2 = turnstile.createSubject()
        
        XCTAssert(subject !== subject2, "Turnstile should create unique subjects each time its called")
    }


    static var allTests : [(String, (TurnstileTests) -> () throws -> Void)] {
        return [
            ("testThatTurnstileReturnsUniqueSubjects", testThatTurnstileReturnsUniqueSubjects),
        ]
    }
}
