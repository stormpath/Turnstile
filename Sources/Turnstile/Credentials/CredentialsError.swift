//
//  CredentialsError.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/27/16.
//
//

/**
 A credential error is usually related to authentication / authorization operations.
 All credentials errors will have a string conversion.
 */
public protocol CredentialsError: Error, CustomStringConvertible { }

/**
 IncorrectCredentialsError represents an error thrown when the credential type
 is valid, but could not be verified to be correct. Eg; "incorrect username or password",
 "invalid Facebook ID", etc.
 */
public struct IncorrectCredentialsError: CredentialsError {
    /// Empty initializer for IncorrectCredentialsError
    public init() {}
    
    /// User-presentable error message
    public var description: String {
        return "Invalid Credentials"
    }
}

/**
 UnsupportedCredentialsError represents an error thrown when the credentials
 presented are not supported for the operation requested.
 */
public struct UnsupportedCredentialsError: CredentialsError {
    /// Empty initializer for UnsupportedCredentialsError
    public init() {}
    
    /// User-presentable error message
    public var description: String {
        return "Unsupported Credentials"
    }
}
