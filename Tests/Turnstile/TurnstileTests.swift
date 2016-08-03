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
    
    func testThatTurnstileReturnsUniqueUsers() {
        let User = turnstile.createUser()
        let User2 = turnstile.createUser()
        
        XCTAssert(User !== User2, "Turnstile should create unique Users each time its called")
    }


    static var allTests : [(String, (TurnstileTests) -> () throws -> Void)] {
        return [
            ("testThatTurnstileReturnsUniqueUsers", testThatTurnstileReturnsUniqueUsers),
        ]
    }
}
