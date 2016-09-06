//
//  FacebookTests.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/8/16.
//
//

@testable import TurnstileWeb
import XCTest

import Turnstile
import Foundation

class FacebookTests: XCTestCase {
    var facebook: Facebook!
    
    override func setUp() {
        let clientID = ProcessInfo.processInfo.environment["FACEBOOK_CLIENT_ID"] ?? ""
        let clientSecret = ProcessInfo.processInfo.environment["FACEBOOK_CLIENT_SECRET"] ?? ""
        
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
        let token = AccessToken(string: "EAAY12345FAKETOKEN")
        
        let account = try? facebook.authenticate(credentials: token)
        
        XCTAssertNil(account, "We should not have authenticated this fake Facebook token")
    }
    
    // Uses the FB graph API to create a test account and get its access token.
    private func createFacebookAccessToken() -> AccessToken? {
        let url = URL(string: "https://graph.facebook.com/\(facebook.clientID)/accounts/test-users?access_token=\(appAccessToken)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        guard let response = (try? urlSession.executeRequest(request: request))?.0 else {
            XCTFail("Could not connect to Facebook")
            return nil
        }
        
        guard let responseJSON = (try? JSONSerialization.jsonObject(with: response, options: [])) as? [String: Any] else {
            XCTFail("Invalid Facebook response")
            return nil
        }
        
        return AccessToken(facebookResponse: responseJSON)
    }
    
    private var appAccessToken: String {
        return facebook.clientID + "%7C" + facebook.clientSecret
    }
    
    static var allTests = [
        ("testThatFacebookAuthenticatesValidAccessToken", testThatFacebookAuthenticatesValidAccessToken),
        ("testThatFacebookDoesntAuthenticateInvalidAccessToken", testThatFacebookDoesntAuthenticateInvalidAccessToken)
    ]
}

extension AccessToken {
    convenience init?(facebookResponse json: [String: Any]) {
        guard let accessToken = json["access_token"] as? String else {
            return nil
        }
        
        self.init(string: accessToken)
    }
}
