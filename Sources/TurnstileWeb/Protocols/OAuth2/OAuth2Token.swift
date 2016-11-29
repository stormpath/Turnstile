//
//  OAuth2Token.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/13/16.
//
//

import Foundation
import Turnstile

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
    
    public convenience init?(json: [String: Any]) {
        guard let accessToken = json["access_token"] as? String,
            let tokenType = json["token_type"] as? String else {
            return nil
        }
        
        let expiresIn = json["expires_in"] as? Int
        let refreshToken: Token? = json["refresh_token"] as? String
        let scope = (json["scope"] as? String)?.components(separatedBy: " ")
        self.init(accessToken: AccessToken(string: accessToken), tokenType: tokenType, expiresIn: expiresIn, refreshToken: refreshToken, scope: scope)
    }
}
