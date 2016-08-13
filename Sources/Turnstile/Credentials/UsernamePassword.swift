//
//  PasswordCredentials.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/27/16.
//
//

/**
 PasswordCredentials represents a username/password, email/password, etc pair.
 */
public class UsernamePassword: Credentials {
    /// Username or email address
    public let username: String
    
    /// Password (unhashed)
    public let password: String
    
    /// Initializer for PasswordCredentials
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
