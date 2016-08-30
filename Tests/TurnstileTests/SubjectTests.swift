import XCTest
@testable import Turnstile

class SubjectTests: XCTestCase {
    var turnstile: Turnstile!
    var subject: Subject!
    var realm: MemoryRealm!
    var sessionManager: MemorySessionManager!
    
    // Constants
    let validCredentials = UsernamePassword(username: "ValidUsername", password: "ValidPassword")
    let invalidCredentials = UsernamePassword(username: "InvalidUsername", password: "InvalidPassword")
    
    override func setUp() {
        sessionManager = MemorySessionManager()
        realm = MemoryRealm()
        turnstile = Turnstile(sessionManager: sessionManager, realm: realm)
        subject = Subject(turnstile: turnstile)
        _ = try? turnstile.realm.register(credentials: validCredentials)
    }
    
    func testThatSubjectCanRegisterWithCredentials() {
        let newCredentials = UsernamePassword(username: "Test", password: "Test")
        _ = try? subject.register(credentials: newCredentials)
        
        _ = try? subject.login(credentials: newCredentials)
        
        XCTAssert(subject.authenticated, "The user should be able to register")
    }
    
    func testThatSubjectCanAuthenticate() {
        _ = try? subject.login(credentials: validCredentials)
        
        XCTAssert(subject.authenticated, "The user should be authenticated")
    }
    
    func testThatSubjectAuthenticationCanPersist() {
        _ = try? subject.login(credentials: validCredentials, persist: true)
        guard let identifier = subject.authDetails?.sessionID else {
            XCTFail("Session identifier must be set for the user.")
            return
        }
        
        let persistedAccount = try? turnstile.sessionManager.restoreAccount(fromSessionID: identifier)
        
        XCTAssert(persistedAccount?.uniqueID == subject.authDetails?.account.uniqueID, "The user authentication should be persisted")
    }
    
    func testThatSubjectCanLogout() {
        _ = try? subject.login(credentials: validCredentials)
        subject.logout()
        
        XCTAssert(!subject.authenticated, "The user should not be authenticated anymore")
    }
    
    func testThatSubjectLogoutIsRemovedFromSession() {
        _ = try? subject.login(credentials: validCredentials, persist: true)
        guard let identifier = subject.authDetails?.sessionID else {
            XCTFail("Session identifier must be set for the user.")
            return
        }
        subject.logout()
        
        do {
            _ = try turnstile.sessionManager.restoreAccount(fromSessionID: identifier)
            XCTFail("The user should not be persisted")
        } catch {}
        
        XCTAssert(!subject.authenticated, "The user should not be authenticated anymore")
    }
    
    static var allTests = [
        ("testThatSubjectCanRegisterWithCredentials", testThatSubjectCanRegisterWithCredentials),
        ("testThatSubjectCanAuthenticate", testThatSubjectCanAuthenticate),
        ("testThatSubjectAuthenticationCanPersist", testThatSubjectAuthenticationCanPersist),
        ("testThatSubjectCanLogout", testThatSubjectCanLogout),
        ("testThatSubjectLogoutIsRemovedFromSession", testThatSubjectLogoutIsRemovedFromSession)
    ]
}
