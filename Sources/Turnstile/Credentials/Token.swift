//
//  TokenCredentials.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/28/16.
//
//

/**
 TokenCredentials represents a computer-generated token, usually for API and
 mobile device authentication, but can also represent password reset tokens / etc.
 */
public class Token: Credentials {
    /// The token as a String
    public let token: String
    
    /// Initializer for TokenCredentials
    public init(token: String) {
        /// User-presentable error message
        self.token = token
    }
}
