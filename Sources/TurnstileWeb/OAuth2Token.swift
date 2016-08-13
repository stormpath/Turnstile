//
//  OAuth2Token.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/13/16.
//
//

import Foundation
import Turnstile
import JSON

/**
 Represents an OAuth 2 Token
 */
public class OAuth2Token {
    public let accessToken: AccessToken
    public let refreshToken: Token?
    public let expiration: Date?
    public let tokenType: String?
    public let scope: [String]?
    
    public init(accessToken: AccessToken, tokenType: String, expiresIn: Int? = nil, refreshToken: Token? = nil, scope: [String]? = nil) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.expiration = expiresIn == nil ? nil : Date(timeIntervalSinceNow: Double(expiresIn!))
        self.scope = scope
    }
    
    public convenience init?(json: JSON) {
        guard let accessToken = json["access_token"]?.string, let tokenType = json["token_type"]?.string else {
            return nil
        }
        let expiresIn = json["expires_in"]?.int
        let refreshToken: Token? = json["refresh_token"]?.string == nil ? nil : json["refresh_token"]!.string!
        let scope = json["scope"]?.string?.components(separatedBy: " ")
        self.init(accessToken: AccessToken(string: accessToken), tokenType: tokenType, expiresIn: expiresIn, refreshToken: refreshToken, scope: scope)
    }
}
