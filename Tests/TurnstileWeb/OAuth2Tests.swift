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
        
        XCTAssert(url.hasPrefix("https://example.com"))
        
        guard let urlComponents = URLComponents.init(string: url) else {
            XCTFail("The URL Generated is invalid")
            return
        }
        
        XCTAssertEqual(urlComponents.path, "/oauth/authorize")
        
        guard let queryItems = urlComponents.queryItems else {
            XCTFail("The URL Generated needs a query string")
            return
        }
        
        XCTAssert(queryItems.contains(URLQueryItem(name: "client_id", value: validClientID)))
        XCTAssert(queryItems.contains(URLQueryItem(name: "response_type", value: "code")))
        XCTAssert(queryItems.contains(URLQueryItem(name: "redirect_uri", value: redirectURL)))
        XCTAssert(queryItems.contains(URLQueryItem(name: "state", value: state)))
        XCTAssert(queryItems.contains(URLQueryItem(name: "scopes", value: scopes.joined(separator: " "))))
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
