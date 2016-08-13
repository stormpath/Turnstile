//
//  TokenCredentials.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/28/16.
//
//

/**
 Token represents a computer-generated token, usually for API and
 mobile device authentication, but can also represent password reset tokens / etc.
 */
public typealias Token = String

/**
 An access token is a token that can be used to authenticate a user with a service.
 */
public class AccessToken: Credentials {
    /// The token as a String
    public let string: Token
    
    /// Initializer for TokenCredentials
    public init(string: Token) {
        /// User-presentable error message
        self.string = string
    }
}
