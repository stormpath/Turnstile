import XCTest
@testable import Turnstile

class MemoryRealmTests: XCTestCase {
    var memoryRealm = MemoryRealm()
    
    let validCredentials = UsernamePassword(username: "ValidUsername", password: "ValidPassword")
    let invalidCredentials = UsernamePassword(username: "InvalidUsername", password: "InvalidPassword")
    let unsupportedCredentials = APIKey(id: "Unsupported", secret: "Unsupported")
    
    override func setUp() {
        memoryRealm = MemoryRealm()
        _ = try? memoryRealm.register(credentials: validCredentials)
    }
    
    func testAuthenticateWithValidCredentialsSucceeds() {
        let account = try? memoryRealm.authenticate(credentials: validCredentials)
        
        XCTAssertNotNil(account, "Authenticating with valid credentials should succeed")
    }
    
    func testAuthenticateWithIncorrectCredentialsThrowsError() {
        do {
            _ = try memoryRealm.authenticate(credentials: invalidCredentials)
            XCTFail("We should not correctly authenticate an account")
        } catch let error {
            
            XCTAssert(error is IncorrectCredentialsError,
                           "We should get an incorrect credentials error")
        }
    }
    
    func testAuthenticateWithUnsupportedCredentialsThrowsError() {
        do {
            _ = try memoryRealm.authenticate(credentials: unsupportedCredentials)
            XCTFail("We should not correctly authenticate an account")
        } catch let error {
            XCTAssert(error is UnsupportedCredentialsError,
                           "We should get an unsupported credentials error")
        }
    }
    
    func testRegisterTakenAccountThrowsError() {
        do {
            _ = try memoryRealm.register(credentials: validCredentials)
            XCTFail("We should not correctly register an account that already is registered.")
        } catch let error {
            XCTAssert(error is AccountTakenError, "We should not be able to register.")
        }
    }
    
    static var allTests : [(String, (MemoryRealmTests) -> () throws -> Void)] {
        return [
            ("testAuthenticateWithValidCredentialsSucceeds", testAuthenticateWithValidCredentialsSucceeds),
            ("testAuthenticateWithIncorrectCredentialsThrowsError", testAuthenticateWithIncorrectCredentialsThrowsError),
            ("testAuthenticateWithUnsupportedCredentialsThrowsError", testAuthenticateWithUnsupportedCredentialsThrowsError),
            ("testRegisterTakenAccountThrowsError", testRegisterTakenAccountThrowsError)
        ]
    }
}
