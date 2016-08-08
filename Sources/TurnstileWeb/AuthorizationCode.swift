//
//  AuthorizationCode.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/7/16.
//
//

import Turnstile

/**
 An authorization code is a one-time use code that's mean to be used in OAuth 2
 authorization code flows.
 */
public struct AuthorizationCode: Credentials {
    public let code: String
    public let redirectURL: String
    
    public init(code: String, redirectURL: String) {
        self.code = code
        self.redirectURL = redirectURL
    }
}
