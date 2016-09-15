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
    let validAuthorizationCode = "VALID_AUTHORIZATION_CODE"
    let invalidAuthorizationCode = "INVALID_AUTHORIZATION_CODE"
    
    override func setUp() {
        oauth2 = OAuth2(clientID: validClientID, clientSecret: validClientSecret, authorizationURL: authorizationURL, tokenURL: tokenURL)
    }
    
    func testThatCorrectLoginLinkIsGenerated() {
        guard let urlComponents = URLComponents(url: oauth2.getLoginLink(redirectURL: redirectURL, state: state, scopes: scopes), resolvingAgainstBaseURL: false) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(urlComponents.scheme, "https")
        XCTAssertEqual(urlComponents.host, "example.com")
        XCTAssertEqual(urlComponents.path, "/oauth/authorize")
        
        let queryItems = urlComponents.queryDictionary
        
        XCTAssertEqual(queryItems["response_type"], "code")
        XCTAssertEqual(queryItems["client_id"], "validClientID")
        XCTAssertEqual(queryItems["redirect_uri"], "https://example.com/callback")
        XCTAssertEqual(queryItems["state"], "12345")
        XCTAssertEqual(queryItems["scope"], "email profile")
    }
    
    func testThatURLComponentsHackIsNeeded() {
        // See https://bugs.swift.org/browse/SR-2570
        #if os(Linux)
            var url = URLComponents(string: "https://test.com/")!
            url.queryItems = [URLQueryItem(name: "test", value: "oh hey")]
            XCTAssertNil(url.queryItems, "https://bugs.swift.org/browse/SR-2570 is solved, remove hack code in OAuth2.swift")
        #endif
    }
    
    func testThatAuthorizationCodeIsExchangedForToken() {
        let endpoint: MockHTTPEndpoint = { request in
            let responseJson: [String: Any] = ["access_token": "ACCESS_TOKEN",
                                               "token_type": "Bearer",
                                               "expires_in": 3600,
                                               "refresh_token": "REFRESH_TOKEN",
                                               "scope": self.scopes.joined(separator: " ")]
            guard let httpBody = request.httpBody else {
                XCTFail("No Body set")
                return (nil, nil)
            }
            let bodyParts = dictionaryFromFormEncodedString(String(data: httpBody, encoding: .utf8))
            
            XCTAssertEqual(bodyParts["client_id"], self.validClientID)
            XCTAssertEqual(bodyParts["client_secret"], self.validClientSecret)
            XCTAssertEqual(bodyParts["redirect_uri"], self.redirectURL)
            XCTAssertEqual(bodyParts["grant_type"], "authorization_code")
            XCTAssertEqual(bodyParts["code"], self.validAuthorizationCode)
            return (try? JSONSerialization.data(withJSONObject: responseJson, options: []), nil)
        }
        
        oauth2._urlSession = { return MockHTTPClient(endpoint: endpoint) }
        
        guard let token = try? oauth2.exchange(authorizationCode: AuthorizationCode(code: validAuthorizationCode, redirectURL: redirectURL)) else {
            XCTFail("Token Exchange failed")
            return
        }
        
        XCTAssertEqual(token.accessToken.string, "ACCESS_TOKEN")
        XCTAssert(token.expiration?.timeIntervalSince(Date(timeIntervalSinceNow: 3600)) ?? 9999.0 < 5.0)
        XCTAssertEqual(token.refreshToken, "REFRESH_TOKEN")
        XCTAssertEqual(token.tokenType, "Bearer")
        XCTAssert(token.scope?.elementsEqual(scopes) ?? false)
    }
    
    func testThatAuthorizationCodeParsesError() {
        let endpoint: MockHTTPEndpoint = { request in
            let responseJson: [String: Any] = ["error": "invalid_client",
                                               "error_description": "ERROR_DESCRIPTION",
                                               "error_uri": "http://error-uri/"]
            return (try? JSONSerialization.data(withJSONObject: responseJson, options: []), nil)
        }
        
        oauth2._urlSession = { return MockHTTPClient(endpoint: endpoint) }
        
        do {
            _ = try oauth2.exchange(authorizationCode: AuthorizationCode(code: validAuthorizationCode, redirectURL: redirectURL))
            XCTFail("The exchange should have failed")
        } catch let e as OAuth2Error {
            XCTAssertEqual(e.code, .invalidClient)
            XCTAssertEqual(e.description, "ERROR_DESCRIPTION")
            XCTAssertEqual(e.uri, "http://error-uri/")
        } catch {
            XCTFail("The error needs to be an OAuth2Error")
        }
    }
    
    static var allTests = [
        ("testThatCorrectLoginLinkIsGenerated", testThatCorrectLoginLinkIsGenerated),
        ("testThatURLComponentsHackIsNeeded", testThatURLComponentsHackIsNeeded),
        ("testThatAuthorizationCodeIsExchangedForToken", testThatAuthorizationCodeIsExchangedForToken),
        ("testThatAuthorizationCodeParsesError", testThatAuthorizationCodeParsesError)
    ]
}

fileprivate func dictionaryFromFormEncodedString(_ input: String?) -> [String: String] {
    var result = [String: String]()
    
    guard let input = input else {
        return result
    }
    let inputPairs = input.components(separatedBy: "&")
    
    for pair in inputPairs {
        let split = pair.components(separatedBy: "=")
        if split.count == 2 {
            if let key = split[0].removingPercentEncoding, let value = split[1].removingPercentEncoding {
                result[key] = value
            }
        }
    }
    return result
}
