import XCTest
@testable import Turnstile

class MemorySessionManagerTests: XCTestCase {
    var sessionManager: MemorySessionManager!
    var turnstile: Turnstile!
    var realm: Realm!
    var user: User!
    
    override func setUp() {
        sessionManager = MemorySessionManager()
        realm = MemoryRealm()
        turnstile = Turnstile(sessionManager: sessionManager, realm: realm)
        
        user = User(turnstile: turnstile)
    }
    
    func testThatSessionManagerCanCreateSessionForUser() {
        let sessionID = sessionManager.createSession(user: user)
        let persistedUser = sessionManager.getUser(identifier: sessionID)
        
        XCTAssert(persistedUser === user, "The user persisted should be the same")
    }
    
    func testThatSessionManagerManagesMultipleUsers() {
        let user2 = User(turnstile: turnstile)
        
        let sessionID = sessionManager.createSession(user: user)
        let sessionID2 = sessionManager.createSession(user: user2)
        
        let persistedUser = sessionManager.getUser(identifier: sessionID)
        let persistedUser2 = sessionManager.getUser(identifier: sessionID2)
        
        XCTAssertNotEqual(sessionID, sessionID2,
                          "Session IDs for two different users should not be the same")
        XCTAssertNotNil(persistedUser, "The user should be persisted")
        XCTAssertNotNil(persistedUser2, "The user should be persisted")
        XCTAssert(persistedUser !== persistedUser2,
                          "Persisted user objects should not be the same")
    }
    
    func testThatSessionManagerDeletesSession() {
        let sessionID = sessionManager.createSession(user: user)
        sessionManager.deleteSession(identifier: sessionID)
        let persistedUser = sessionManager.getUser(identifier: sessionID)
        
        XCTAssertNil(persistedUser, "The user should be deleted")
    }
    
    static var allTests : [(String, (MemorySessionManagerTests) -> () throws -> Void)] {
        return [
            ("testThatSessionManagerCanCreateSessionForUser", testThatSessionManagerCanCreateSessionForUser),
            ("testThatSessionManagerManagesMultipleUsers", testThatSessionManagerManagesMultipleUsers),
            ("testThatSessionManagerDeletesSession", testThatSessionManagerDeletesSession)
        ]
    }
}
