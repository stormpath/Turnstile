//
//  OAuth2Tests.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/8/16.
//
//

@testable import TurnstileWeb
import XCTest

import Foundation

class OAuth2Tests: XCTestCase {
    var oauth2: OAuth2!
    let validClientID = "validClientID"
    let validClientSecret = "validClientSecret"
    let authorizationURL = "https://example.com/oauth/authorize"
    let tokenURL = "https://example.com/oauth/token"
    let redirectURL = "https://example.com/callback"
    let state = "12345"
    let scopes = ["email", "profile"]
    
    override func setUp() {
        oauth2 = OAuth2(clientID: validClientID, clientSecret: validClientSecret, authorizationURL: authorizationURL, tokenURL: tokenURL)
    }
    
    func testThatCorrectLoginLinkIsGenerated() {
        let url = oauth2.getLoginLink(redirectURL: redirectURL, state: state, scopes: scopes)
        
        XCTAssertEqual(url, "https://example.com/oauth/authorize?response_type=code&client_id=validClientID&redirect_uri=https://example.com/callback&state=12345&scopes=email%20profile")
    }
    
    func testThatAuthorizationCodeIsExchangedForToken() {
        // NOT IMPLEMENTED - need to mock HTTPClient
    }
    
    func testThatAuthorizationCodeParsesError() {
        // NOT IMPLEMENTED - need to mock HTTPClient
    }
    
    static var allTests = [
        ("testThatCorrectLoginLinkIsGenerated", testThatCorrectLoginLinkIsGenerated)
    ]
}
