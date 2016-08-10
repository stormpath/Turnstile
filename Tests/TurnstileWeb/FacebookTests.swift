//
//  FacebookTests.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/8/16.
//
//

@testable import TurnstileWeb
import XCTest

import HTTP
import JSON
import Turnstile
import Foundation

class FacebookTests: XCTestCase {
    var facebook: Facebook!
    
    override func setUp() {
        #if os(OSX) || os(iOS)
            let clientID = ProcessInfo.processInfo.environment["FACEBOOK_CLIENT_ID"] ?? ""
            let clientSecret = ProcessInfo.processInfo.environment["FACEBOOK_CLIENT_SECRET"] ?? ""
        #elseif os(Linux)
            let clientID = ProcessInfo.processInfo().environment["FACEBOOK_CLIENT_ID"] ?? ""
            let clientSecret = ProcessInfo.processInfo().environment["FACEBOOK_CLIENT_SECRET"] ?? ""
        #endif
        
        facebook = Facebook(clientID: clientID, clientSecret: clientSecret)
    }
    
    func testThatFacebookAuthenticatesValidAccessToken() {
        guard let token = createFacebookAccessToken() else {
            XCTFail("Cannot create Facebook access token")
            return
        }
        
        let account = try? facebook.authenticate(credentials: token)
        
        XCTAssertNotNil(account, "We need to get a valid FB account")
    }
    
    func testThatFacebookDoesntAuthenticateInvalidAccessToken() {
        let token = Token(token: "EAAY12345FAKETOKEN")
        
        let account = try? facebook.authenticate(credentials: token)
        
        XCTAssertNil(account, "We should not have authenticated this fake Facebook token")
    }
    
    // Uses the FB graph API to create a test account and get its access token.
    private func createFacebookAccessToken() -> Token? {
        let url = "https://graph.facebook.com/\(facebook.clientID)/accounts/test-users?access_token=\(appAccessToken)"
        let request = try! Request(method: .post, uri: url)
        request.headers["Accept"] = "application/json"
        
        guard let response = try? Client<TLSClientStream>.respond(to: request) else {
            XCTFail("Could not connect to Facebook")
            return nil
        }
        return Token(facebookResponse: response)
    }
    
    private var appAccessToken: String {
        return facebook.clientID + "%7C" + facebook.clientSecret
    }
    
    static var allTests = [
        ("testThatFacebookAuthenticatesValidAccessToken", testThatFacebookAuthenticatesValidAccessToken),
        ("testThatFacebookDoesntAuthenticateInvalidAccessToken", testThatFacebookDoesntAuthenticateInvalidAccessToken)
    ]
}

extension Token {
    init?(facebookResponse response: Response) {
        guard let accessToken = response.json?["access_token"]?.string else {
            return nil
        }
        
        self.init(token: accessToken)
    }
}

