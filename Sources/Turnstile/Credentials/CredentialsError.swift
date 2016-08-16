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
public protocol CredentialsError: TurnstileError { }

/**
 IncorrectCredentialsError represents an error thrown when the credential type
 is valid, but could not be verified to be correct. Eg; "incorrect username or password",
 "invalid Facebook ID", etc.
 */
public struct IncorrectCredentialsError: CredentialsError {
    /// Empty initializer for IncorrectCredentialsError
    public init() {}
    
    /// User-presentable error message
    public let description = "Invalid Credentials"
}

/**
 UnsupportedCredentialsError represents an error thrown when the credentials
 presented are not supported for the operation requested.
 */
public struct UnsupportedCredentialsError: CredentialsError {
    /// Empty initializer for UnsupportedCredentialsError
    public init() {}
    
    /// User-presentable error message
    public let description = "Unsupported Credentials"
}

/**
 AccountTakenError represents an error where a username, email, or other account identifier
 being registered with a Realm is already used.
 */
public struct AccountTakenError: CredentialsError {
    /// Empty initializer for AccountTakenError
    public init() {}
    
    /// User-presentable error message
    public let description = "The account is already registered."
}
