import XCTest
@testable import Turnstile

class UserTests: XCTestCase {
    var turnstile: Turnstile!
    var user: User!
    var realm: MemoryRealm!
    var sessionManager: MemorySessionManager!
    
    // Constants
    let validCredentials = UsernamePassword(username: "ValidUsername", password: "ValidPassword")
    let invalidCredentials = UsernamePassword(username: "InvalidUsername", password: "InvalidPassword")
    
    override func setUp() {
        sessionManager = MemorySessionManager()
        realm = MemoryRealm()
        turnstile = Turnstile(sessionManager: sessionManager, realm: realm)
        user = User(turnstile: turnstile)
        _ = try? turnstile.realm.register(credentials: validCredentials)
    }
    
    func testThatUserCanRegisterWithCredentials() {
        let newCredentials = UsernamePassword(username: "Test", password: "Test")
        _ = try? user.register(credentials: newCredentials)
        
        _ = try? user.login(credentials: newCredentials)
        
        XCTAssert(user.authenticated, "The user should be able to register")
    }
    
    func testThatUserCanAuthenticate() {
        _ = try? user.login(credentials: validCredentials)
        
        XCTAssert(user.authenticated, "The user should be authenticated")
    }
    
    func testThatUserAuthenticationCanPersist() {
        _ = try? user.login(credentials: validCredentials, persist: true)
        guard let identifier = user.authDetails?.sessionID else {
            XCTFail("Session identifier must be set for the user.")
            return
        }
        
        let persistedUser = turnstile.sessionManager.getUser(identifier: identifier)
        
        XCTAssert(persistedUser === user, "The user authentication should be persisted")
    }
    
    func testThatUserCanLogout() {
        _ = try? user.login(credentials: validCredentials)
        user.logout()
        
        XCTAssert(!user.authenticated, "The user should not be authenticated anymore")
    }
    
    func testThatUserLogoutIsRemovedFromSession() {
        _ = try? user.login(credentials: validCredentials, persist: true)
        guard let identifier = user.authDetails?.sessionID else {
            XCTFail("Session identifier must be set for the user.")
            return
        }
        user.logout()
        
        let persistedUser = turnstile.sessionManager.getUser(identifier: identifier)
        
        XCTAssert(!user.authenticated, "The user should not be authenticated anymore")
        XCTAssert(persistedUser == nil, "The user should not be persisted")
    }
    
    static var allTests = [
        ("testThatUserCanRegisterWithCredentials", testThatUserCanRegisterWithCredentials),
        ("testThatUserCanAuthenticate", testThatUserCanAuthenticate),
        ("testThatUserAuthenticationCanPersist", testThatUserAuthenticationCanPersist),
        ("testThatUserCanLogout", testThatUserCanLogout),
        ("testThatUserLogoutIsRemovedFromSession", testThatUserLogoutIsRemovedFromSession)
    ]
}
