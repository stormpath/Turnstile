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
public struct AuthorizationCode {
    /// The authorization code
    public let code: String
    
    /// The redirect URL bound to the authorization code
    public let redirectURL: String
    
    /// Initializer
    public init(code: String, redirectURL: String) {
        self.code = code
        self.redirectURL = redirectURL
    }
}

/**
 Error when the authorization code supplied could not be verified
 */
public struct InvalidAuthorizationCodeError: Error, CredentialsError {
    /// Empty initializer for InvalidAuthorizationCodeError
    public init() {}
    
    /// User-presentable error message
    public var description: String {
        return "The authorization code supplied could not be verified"
    }
}
