import XCTest
@testable import Turnstile

class MemorySessionManagerTests: XCTestCase {
    var sessionManager: MemorySessionManager!
    var turnstile: Turnstile!
    var realm: Realm!
    var user: Subject!
    
    override func setUp() {
        sessionManager = MemorySessionManager()
        realm = MemoryRealm()
        turnstile = Turnstile(sessionManager: sessionManager, realm: realm)
        
        user = Subject(turnstile: turnstile)
    }
    
    func testThatSessionManagerCanCreateSessionForSubject() {
        let sessionID = sessionManager.createSession(user: user)
        let persistedSubject = try? sessionManager.getSubject(identifier: sessionID)
        
        XCTAssert(persistedSubject === user, "The user persisted should be the same")
    }
    
    func testThatSessionManagerManagesMultipleSubjects() {
        let user2 = Subject(turnstile: turnstile)
        
        let sessionID = sessionManager.createSession(user: user)
        let sessionID2 = sessionManager.createSession(user: user2)
        
        let persistedSubject = try? sessionManager.getSubject(identifier: sessionID)
        let persistedSubject2 = try? sessionManager.getSubject(identifier: sessionID2)
        
        XCTAssertNotEqual(sessionID, sessionID2,
                          "Session IDs for two different users should not be the same")
        XCTAssertNotNil(persistedSubject, "The user should be persisted")
        XCTAssertNotNil(persistedSubject2, "The user should be persisted")
        XCTAssert(persistedSubject !== persistedSubject2,
                          "Persisted user objects should not be the same")
    }
    
    func testThatSessionManagerDeletesSession() {
        let sessionID = sessionManager.createSession(user: user)
        sessionManager.destroySession(identifier: sessionID)
        let persistedSubject = try? sessionManager.getSubject(identifier: sessionID)
        
        XCTAssertNil(persistedSubject, "The user should be deleted")
    }
    
    func testThatSessionManagerErrorsForUnknownSessions() {
        let unknownSessionID = "invalidSessionID"
        
        do {
            try sessionManager.getSubject(identifier: unknownSessionID)
            XCTFail("An error should be thrown")
        } catch let error {
            XCTAssert(error is InvalidSessionError, "The error should be an invalid session")
        }
    }
    
    static var allTests = [
        ("testThatSessionManagerCanCreateSessionForSubject", testThatSessionManagerCanCreateSessionForSubject),
        ("testThatSessionManagerManagesMultipleSubjects", testThatSessionManagerManagesMultipleSubjects),
        ("testThatSessionManagerDeletesSession", testThatSessionManagerDeletesSession)
    ]
}
