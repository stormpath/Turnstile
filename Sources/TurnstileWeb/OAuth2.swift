//
//  OAuth2.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/7/16.
//
//

import Turnstile
import Foundation
import HTTP
import Transport
import JSON

public class OAuth2 {
    public let clientID: String
    public let clientSecret: String
    public let authorizationURL: String
    public let tokenURL: String
    
    public init(clientID: String, clientSecret: String, authorizationURL: String, tokenURL: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authorizationURL = authorizationURL
        self.tokenURL = tokenURL
    }
    
    public func getLoginLink(redirectURI: String, state: String, scopes: [String] = []) -> String {
        // TODO: serialize these better
        var loginLink = authorizationURL + "?"
        loginLink += "response_type=code"
        loginLink += "&client_id=" + clientID
        loginLink += "&redirect_uri=" + redirectURI
        loginLink += "&state=" + state
        loginLink += "&scopes=" + scopes.joined(separator: "%20")
        
        return loginLink
    }
    
    public func exchange(authorizationCode: AuthorizationCode) throws -> Token {
        // TODO: serialize these better
        let url = tokenURL + "?client_id=\(clientID)&redirect_uri=\(authorizationCode.redirectURI)&client_secret=\(clientSecret)&code=\(authorizationCode.code)"
        let request = try! Request(method: .get, uri: url)
        request.headers["Accept"] = "application/json"
        
        guard let response = try? Client<TCPClientStream>.respond(to: request),
            let accessToken = response.json?["access_token"]?.string else {
                throw UnsupportedCredentialsError()
        }
        return Token(token: accessToken)
    }
}

/** 
 Taken from https://github.com/vapor/vapor 0.16. MIT Licensed
 */
extension Message {
    public var json: JSON? {
        get {
            if let existing = storage["json"] as? JSON {
                return existing
            } else if let type = headers["Content-Type"], type.contains("application/json") {
                guard case let .data(body) = body else { return nil }
                guard let json = try? JSON(bytes: body) else { return nil }
                storage["json"] = json
                return json
            } else {
                return nil
            }
        }
    }
}
