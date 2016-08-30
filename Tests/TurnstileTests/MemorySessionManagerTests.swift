import XCTest
@testable import Turnstile

class MemorySessionManagerTests: XCTestCase {
    var sessionManager: MemorySessionManager!
    var account: Account!
    
    override func setUp() {
        sessionManager = MemorySessionManager()
        account = MockAccount(uniqueID: "account1")
    }
    
    func testThatSessionManagerCanCreateSessionForSubject() {
        let sessionID = sessionManager.createSession(account: account)
        let restoredAccount = try? sessionManager.restoreAccount(fromSessionID: sessionID)
        
        XCTAssert(restoredAccount?.uniqueID == account.uniqueID, "The restored account should have the same UID")
    }
    
    func testThatSessionManagerPersistsMultipleAccounts() {
        let account2 = MockAccount(uniqueID: "account2")
        
        let sessionID = sessionManager.createSession(account: account)
        let sessionID2 = sessionManager.createSession(account: account2)
        
        let persistedAccount = try? sessionManager.restoreAccount(fromSessionID: sessionID)
        let persistedAccount2 = try? sessionManager.restoreAccount(fromSessionID: sessionID2)
        
        XCTAssertNotEqual(sessionID, sessionID2,
                          "Session IDs for two different users should not be the same")
        XCTAssertNotNil(persistedAccount, "The user should be persisted")
        XCTAssertNotNil(persistedAccount2, "The user should be persisted")
        XCTAssert(persistedAccount?.uniqueID != persistedAccount2?.uniqueID,
                          "Persisted user objects should not be the same")
    }
    
    func testThatSessionManagerDeletesSession() {
        let sessionID = sessionManager.createSession(account: account)
        sessionManager.destroySession(identifier: sessionID)
        let persistedAccount = try? sessionManager.restoreAccount(fromSessionID: sessionID)
        
        XCTAssertNil(persistedAccount, "The session should be deleted")
    }
    
    func testThatSessionManagerErrorsForUnknownSessions() {
        let unknownSessionID = "invalidSessionID"
        
        do {
            _ = try sessionManager.restoreAccount(fromSessionID: unknownSessionID)
            XCTFail("An error should be thrown")
        } catch let error {
            XCTAssert(error is InvalidSessionError, "The error should be an invalid session")
        }
    }
    
    static var allTests = [
        ("testThatSessionManagerCanCreateSessionForSubject", testThatSessionManagerCanCreateSessionForSubject),
        ("testThatSessionManagerPersistsMultipleAccounts", testThatSessionManagerPersistsMultipleAccounts),
        ("testThatSessionManagerDeletesSession", testThatSessionManagerDeletesSession),
        ("testThatSessionManagerErrorsForUnknownSessions", testThatSessionManagerErrorsForUnknownSessions)
    ]
}

fileprivate struct MockAccount: Account {
    var uniqueID: String
}
