import XCTest
@testable import Turnstile

class SubjectTests: XCTestCase {
    var turnstile: Turnstile!
    var user: Subject!
    var realm: MemoryRealm!
    var sessionManager: MemorySessionManager!
    
    // Constants
    let validCredentials = UsernamePassword(username: "ValidUsername", password: "ValidPassword")
    let invalidCredentials = UsernamePassword(username: "InvalidUsername", password: "InvalidPassword")
    
    override func setUp() {
        sessionManager = MemorySessionManager()
        realm = MemoryRealm()
        turnstile = Turnstile(sessionManager: sessionManager, realm: realm)
        user = Subject(turnstile: turnstile)
        _ = try? turnstile.realm.register(credentials: validCredentials)
    }
    
    func testThatSubjectCanRegisterWithCredentials() {
        let newCredentials = UsernamePassword(username: "Test", password: "Test")
        _ = try? user.register(credentials: newCredentials)
        
        _ = try? user.login(credentials: newCredentials)
        
        XCTAssert(user.authenticated, "The user should be able to register")
    }
    
    func testThatSubjectCanAuthenticate() {
        _ = try? user.login(credentials: validCredentials)
        
        XCTAssert(user.authenticated, "The user should be authenticated")
    }
    
    func testThatSubjectAuthenticationCanPersist() {
        _ = try? user.login(credentials: validCredentials, persist: true)
        guard let identifier = user.authDetails?.sessionID else {
            XCTFail("Session identifier must be set for the user.")
            return
        }
        
        let persistedSubject = try? turnstile.sessionManager.getSubject(identifier: identifier)
        
        XCTAssert(persistedSubject === user, "The user authentication should be persisted")
    }
    
    func testThatSubjectCanLogout() {
        _ = try? user.login(credentials: validCredentials)
        user.logout()
        
        XCTAssert(!user.authenticated, "The user should not be authenticated anymore")
    }
    
    func testThatSubjectLogoutIsRemovedFromSession() {
        _ = try? user.login(credentials: validCredentials, persist: true)
        guard let identifier = user.authDetails?.sessionID else {
            XCTFail("Session identifier must be set for the user.")
            return
        }
        user.logout()
        
        do {
            _ = try turnstile.sessionManager.getSubject(identifier: identifier)
            XCTFail("The user should not be persisted")
        } catch {}
        
        XCTAssert(!user.authenticated, "The user should not be authenticated anymore")
    }
    
    static var allTests = [
        ("testThatSubjectCanRegisterWithCredentials", testThatSubjectCanRegisterWithCredentials),
        ("testThatSubjectCanAuthenticate", testThatSubjectCanAuthenticate),
        ("testThatSubjectAuthenticationCanPersist", testThatSubjectAuthenticationCanPersist),
        ("testThatSubjectCanLogout", testThatSubjectCanLogout),
        ("testThatSubjectLogoutIsRemovedFromSession", testThatSubjectLogoutIsRemovedFromSession)
    ]
}
