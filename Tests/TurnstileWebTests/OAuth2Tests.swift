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
    let authorizationURL = URL(string: "https://example.com/oauth/authorize")!
    let tokenURL = URL(string: "https://example.com/oauth/token")!
    let redirectURL = "https://example.com/callback"
    let state = "12345"
    let scopes = ["email", "profile"]
    
    override func setUp() {
        oauth2 = OAuth2(clientID: validClientID, clientSecret: validClientSecret, authorizationURL: authorizationURL, tokenURL: tokenURL)
    }
    
    func testThatCorrectLoginLinkIsGenerated() {
        guard let urlComponents = URLComponents(url: oauth2.getLoginLink(redirectURL: redirectURL, state: state, scopes: scopes), resolvingAgainstBaseURL: false) else {
            XCTFail()
            return
        }
        
        //XCTAssertEqual(url, URL(string: "https://example.com/oauth/authorize?response_type=code&client_id=validClientID&redirect_uri=https://example.com/callback&state=12345&scope=email%20profile")!)
        
        XCTAssertEqual(urlComponents.scheme, "https")
        XCTAssertEqual(urlComponents.host, "example.com")
        XCTAssertEqual(urlComponents.path, "/oauth/authorize")
        
        guard let queryItems = urlComponents.queryItems else {
            XCTFail("No query parameters found in the generated URL")
            return
        }
        
        XCTAssert(queryItems.contains(URLQueryItem(name: "response_type", value: "code")))
        XCTAssert(queryItems.contains(URLQueryItem(name: "client_id", value: "validClientID")))
        XCTAssert(queryItems.contains(URLQueryItem(name: "redirect_uri", value: "https://example.com/callback")))
        XCTAssert(queryItems.contains(URLQueryItem(name: "state", value: "12345")))
        XCTAssert(queryItems.contains(URLQueryItem(name: "scope", value: "email profile")))
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
