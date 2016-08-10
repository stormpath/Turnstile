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
        let persistedUser = try? sessionManager.getUser(identifier: sessionID)
        
        XCTAssert(persistedUser === user, "The user persisted should be the same")
    }
    
    func testThatSessionManagerManagesMultipleUsers() {
        let user2 = User(turnstile: turnstile)
        
        let sessionID = sessionManager.createSession(user: user)
        let sessionID2 = sessionManager.createSession(user: user2)
        
        let persistedUser = try? sessionManager.getUser(identifier: sessionID)
        let persistedUser2 = try? sessionManager.getUser(identifier: sessionID2)
        
        XCTAssertNotEqual(sessionID, sessionID2,
                          "Session IDs for two different users should not be the same")
        XCTAssertNotNil(persistedUser, "The user should be persisted")
        XCTAssertNotNil(persistedUser2, "The user should be persisted")
        XCTAssert(persistedUser !== persistedUser2,
                          "Persisted user objects should not be the same")
    }
    
    func testThatSessionManagerDeletesSession() {
        let sessionID = sessionManager.createSession(user: user)
        sessionManager.destroySession(identifier: sessionID)
        let persistedUser = try? sessionManager.getUser(identifier: sessionID)
        
        XCTAssertNil(persistedUser, "The user should be deleted")
    }
    
    func testThatSessionManagerErrorsForUnknownSessions() {
        let unknownSessionID = "invalidSessionID"
        
        do {
            try sessionManager.getUser(identifier: unknownSessionID)
            XCTFail("An error should be thrown")
        } catch let error {
            XCTAssert(error is InvalidSessionError, "The error should be an invalid session")
        }
    }
    
    static var allTests = [
        ("testThatSessionManagerCanCreateSessionForUser", testThatSessionManagerCanCreateSessionForUser),
        ("testThatSessionManagerManagesMultipleUsers", testThatSessionManagerManagesMultipleUsers),
        ("testThatSessionManagerDeletesSession", testThatSessionManagerDeletesSession)
    ]
}
